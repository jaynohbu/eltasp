<!--  #INCLUDE FILE="transaction.txt" -->
<%
    Option Explicit
    Response.Charset = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="connection.asp" -->
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>	
<title>Client Quick Add</title>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
<script language='javascript'>
window.name = 'AddClient';
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

function closeReturn(s) 
{
	window.returnValue = s;
	window.close();
}
</script>
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
	background-image: url(/ASP/Images/bullet_quick.gif);
	background-repeat: no-repeat;
	background-position: left center;
	padding-top: 0px;
	padding-right: 0px;
	padding-bottom: 0px;
	padding-left: 6px;
}
-->
</style>
</head>
<!--  #INCLUDE FILE="header.asp" -->

<%
DIM rs,SQL
Dim sType,strBizType
Dim aCountryCodeArry(),aCountryArry(),aConIndex
Dim vDbaName,vAddress,vCity,vState,vCountry,vFirstName,vMiddleName,vLastName,vPhone,vFax,vCell,vEmail,vCountryName,vZip
Dim aStateCode(52),aStateName(52),aStateIndex
Dim Action,vAnotherAccount,AddressInfo,vTaxId
Dim aDbaName(),aDbaNameIndex
Dim OriginalDbaName
Dim oldConsignee,oldShipper,oldAgent,oldCarrier,oldTrucker,oldWarehousing,oldCFS,oldBroker,oldGovt,oldSpecial,oldVendor
Dim chkConsignee,chkShipper,chkAgent,chkCarrier,chkTrucker,chkWarehousing,chkCFS,chkBroker,chkGovt,chkSpecial,chkVendor
Dim PostBack	
Dim i,addPhoneFax
		PostBack = Request.QueryString("PostBack")
        if PostBack = "" then PostBack = true
		
		if Not ( PostBack ) then
			vDbaName = Request.QueryString("s")
			addPhoneFax = Request.QueryString("addPhoneFax")
			vDbaName = Replace(vDbaName,"________","&")
			vDbaName = Replace(vDbaName,"^^^^^^^^","'")
			Session("OriginalDbaName") = vDbaName			
			Session("addPhoneFax") = addPhoneFax
		else
			vDbaName =  Request("txtDbaName")
		end if

		OriginalDbaName	= Session("OriginalDbaName")	

		sType = Request.QueryString("Type")
		Action = Request.QueryString("Action")
		
		select case sType
			case "Shipper" 
				strBizType = "Shipper"
			case "Consignee" 
				strBizType = "Consignee"
			case "Notify" 
				strBizType = "Notify"
			case "Agent" 
				strBizType = "Agent"
			case "Customer" 
				strBizType = "Customer"
			case "Vendor" 
				strBizType = "Vendor"
			case "Broker" 
				strBizType = "Broker"
		end select

		Set rs = Server.CreateObject("ADODB.Recordset")
					
	    call get_country					
		
		select case Action
			case "prev" 
				 vDbaName = get_prev_dba( vDbaName )
				 call load_client( vDbaName )				 
			case "next" 
 				 vDbaName = get_next_dba( vDbaName )
				 call load_client( vDbaName )				 
			case "reset" 
 				 vDbaName = ""
				 call load_client( vDbaName )				 
			case "save" 
				 call read_screen	
				 call save_client( vDbaName )
				 Session("addPhoneFax") = ""
				 response.write "<script language='javascript'>closeReturn(""" & AddressInfo & """);</script>"
			case "" 
				 call load_client( vDbaName )
		end select

		Set rs=Nothing
		
		DIM isExist
		if( cLng(vAnotherAccount) = cLng(elt_account_number) ) then isExist = true
		if isExist and Not PostBack then Session("OriginalDbaName") = ""
		
		call get_all_state
		
%>

<%
function get_first_dba()
DIM first_dba

first_dba = ""

	SQL = "select TOP 1 dba_name from organization where elt_account_number = " & elt_account_number & " order by dba_name"
	Set rs = eltConn.execute (SQL)

	if NOT rs.eof and NOT rs.bof then
		first_dba = rs("dba_name")
	end if
	rs.Close	

	get_first_dba = first_dba	

end function
%>

<%
function get_last_dba()
DIM last_dba

last_dba = ""

	SQL = "select TOP 1 dba_name from organization where elt_account_number = " & elt_account_number & " order by dba_name desc"
	Set rs = eltConn.execute (SQL)

	if NOT rs.eof and NOT rs.bof then
		last_dba = rs("dba_name")
	end if
	rs.Close	

	get_last_dba = last_dba	

end function
%>

<%
function get_current_dba_index( dba )

	for i = 0 to aDbaNameIndex 
		if aDbaName(i) = dba then	
			if i < aDbaNameIndex then
				get_current_dba_index = i
				exit function
			end if
		end if
	next
	get_current_dba_index = -1
end function
%>

<% 
function get_next_dba( dba )
DIM next_dba
dba = Replace(dba,"'","''")
	next_dba = ""

	if 	dba = "" then
		dba = OriginalDbaName
		if dba = "" then
			dba = get_first_dba()
		end if
		next_dba = dba
	else
		if 	dba = OriginalDbaName then
			next_dba = get_first_dba()
		else
			SQL = "select TOP 1 dba_name from organization where elt_account_number = " & elt_account_number & " AND dba_name > N'" & dba & "' order by dba_name"
			Set rs = eltConn.execute (SQL)
		
			if NOT rs.eof and NOT rs.bof then
				next_dba = rs("dba_name")
			end if
			rs.Close	
		
			if next_dba = "" then
				if not OriginalDbaName = "" then
					next_dba = OriginalDbaName
				else
					next_dba = get_first_dba()
				end if
			end if
		end if	
	end if
	
	get_next_dba = next_dba	
	
end function
%>

<% 
function get_prev_dba( dba )
DIM prev_dba
dba = Replace(dba,"'","''")
	prev_dba = ""

	if 	dba = "" then
		dba = OriginalDbaName
		if dba = "" then
			dba = get_last_dba()
		end if		
		prev_dba = dba
	else
		if 	dba = OriginalDbaName then	
			prev_dba = get_last_dba()
		else
			SQL = "select TOP 1 dba_name from organization where elt_account_number = " & elt_account_number & " AND dba_name < N'" & dba & "' order by dba_name desc"
			Set rs = eltConn.execute (SQL)
		
			if NOT rs.eof and NOT rs.bof then
				prev_dba = rs("dba_name")
			end if
			rs.Close	
			if prev_dba = "" then
				if not OriginalDbaName = "" then
					prev_dba = OriginalDbaName
				else
					prev_dba = get_last_dba()
				end if
			end if
		end if
	end if
	get_prev_dba = prev_dba	
	
end function
%>

<%
sub read_screen
	 vDbaName = Request("txtDbaName")	
	 vTaxId = Request("txtTaxId")	
	 vAddress = Request("txtAddress")	
	 vCity = Request("txtCity")	
	 vState = Request("lstState")	
	 vZip = Request("txtZip")	
	 vCountry = Request("lstCountry")	
	 vFirstName = Request("txtFirstName")	
	 vMiddleName = Request("txtMiddleName")	
	 vLastName = Request("txtvLastName")	
	 vPhone = Request("txtPhone")	
	 vFax = Request("txtFax")	
	 vCell = Request("txtCell")	
	 vEmail = Request("txtEmail")	

	 chkConsignee = Request("chkConsignee")	
	 chkShipper = Request("chkShipper")	
	 chkAgent = Request("chkAgent")	
	 chkCarrier = Request("chkCarrier")	
	 chkTrucker = Request("chkTrucker")	
	 chkWarehousing = Request("chkWarehousing")	
	 chkCFS = Request("chkCFS")	
	 chkBroker = Request("chkBroker")	
	 chkGovt = Request("chkGovt")	
	 chkSpecial = Request("chkSpecial")	
	 chkVendor = Request("chkVendor")	

	 chkConsignee = convertToYes( chkConsignee )
	 chkShipper = convertToYes( chkShipper )
	 chkAgent = convertToYes( chkAgent )
	 chkCarrier = convertToYes( chkCarrier )
	 chkTrucker = convertToYes( chkTrucker )
	 chkWarehousing = convertToYes( chkWarehousing )
	 chkCFS = convertToYes( chkCFS )
	 chkBroker = convertToYes( chkBroker )
	 chkGovt = convertToYes( chkGovt )
	 chkSpecial = convertToYes( chkSpecial )
	 chkVendor = convertToYes( chkVendor )
	 
     vCountryName = ""
	 for i=0 to aConIndex 
	 	if aCountryCodeArry(i) = vCountry then
			vCountryName = aCountryArry(i)
			exit for
		end if	 
	 next
 
end sub
%>
<%
function convertToYes ( s )
if UCASE(s) = "ON" or UCASE(s) = "Y" then
	convertToYes = "Y"
else
	convertToYes = ""
end if
end function
%>

<%
sub save_client( s )
DIM newOrgNum,tmpS


newOrgNum = 0
tmpS = Replace(s,"'","''")
SQL = "select org_account_number, dba_name, business_fed_taxid, business_address,business_city, business_state,business_zip, b_country_code,business_phone,business_fax,owner_lname,owner_fname,owner_mname,owner_phone,owner_email from organization where elt_account_number = " & elt_account_number & " and UPPER(dba_name) = N'" & UCase(tmpS) &"'"	

	Set rs = eltConn.execute (SQL)
	
	If rs.EOF Then
		rs.close()
		
		SQL= "select max(org_account_number) as newOrgNum from organization where elt_account_number = " & elt_account_number
		rs.Open SQL, eltConn, , , adCmdText
		If Not rs.EOF And IsNull(rs("newOrgNum"))=False Then
			newOrgNum = CLng(rs("newOrgNum")) + 1
		Else
			newOrgNum=1
		End If
		rs.Close
	else
		rs.Close	
	end if
		SQL = "select elt_account_number,org_account_number, dba_name, account_status,business_fed_taxid,business_address,business_city, business_state,business_zip, b_country_code,business_country,business_phone,business_fax,owner_lname,owner_fname,owner_mname,owner_phone,owner_email,is_shipper,is_consignee,is_agent,is_carrier,z_is_trucker,z_is_warehousing,z_is_cfs,z_is_broker,z_is_govt,z_is_special,is_vendor,date_opened,last_update from organization where elt_account_number = " & elt_account_number & " and UPPER(dba_name) = N'" & UCase(tmpS) &"'"	
	
	 rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText	

	 If rs.EOF Then
		rs.AddNew
		rs("elt_account_number")=elt_account_number	
		rs("org_account_number")=newOrgNum	
		rs("date_opened")=date	
		rs("last_update")=date	
	 else
		newOrgNum = rs("org_account_number")	 
		rs("last_update")=date	
	 end if

	 rs("account_status") = "A"
	 rs("dba_name") = vDbaName
	 rs("business_fed_taxid")=vTaxId
	 rs("business_address") = vAddress
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
			 
'////////////////////////////// updated by iMoon 11-22-2006
	 rs("is_consignee") = chkConsignee
	 rs("is_shipper") = chkShipper
	 rs("is_agent") = chkAgent
	 rs("is_carrier") = chkCarrier
	 rs("z_is_trucker") = chkTrucker
	 rs("z_is_warehousing") = chkWarehousing
	 rs("z_is_cfs") = chkCFS
	 rs("z_is_broker") = chkBroker
	 rs("z_is_govt") = chkGovt
	 rs("z_is_special") = chkSpecial
	 rs("is_vendor") = chkVendor
	 
	 if chkAgent = "Y" or chkCarrier = "Y" or chkTrucker = "Y" or chkWarehousing = "Y" or chkCFS = "Y" or chkBroker = "Y" then
		 rs("is_vendor") = "Y"
	 end if 	 

 	 rs.Update
	 rs.Close
	 
	AddressInfo = ""
	addPhoneFax = Session("addPhoneFax")
	if addPhoneFax = "yes" then
		if Not Trim(vState)="" then
			AddressInfo=newOrgNum & "-" & vDbaName & "^^^" & vAddress & "^^^" & vCity & "," & vState & " " & vZip & "," & vCountryName & "^^^" & "Tel:" & vPhone & " " & "Fax:" & vFax
		else
			AddressInfo=newOrgNum & "-" & vDbaName & "^^^" & vAddress & "^^^" & vCity & "," & vCountryName & "^^^" & "Tel:" & vPhone & " " & "Fax:" & vFax
		end if
	else
		if Not Trim(vState)="" then
			AddressInfo=newOrgNum & "-" & vDbaName & "^^^" & vAddress & "^^^" & vCity & "," & vState & " " & vZip & "," & vCountryName & "^^^" & vPhone
		else
			AddressInfo=newOrgNum & "-" & vDbaName & "^^^" & vAddress & "^^^" & vCity & "," & vCountryName & "^^^" & vPhone
		end if
	end if
end sub
%>

<%
sub load_client( s )
Dim tmpS
tmpS = Replace(s,"'","''")
'On Error Resume Next :
SQL = "select org_account_number, dba_name, business_fed_taxid,business_address,business_city, business_state,business_zip, b_country_code,business_phone,business_fax,owner_lname,owner_fname,owner_mname,owner_phone,owner_email, "_
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
& " from organization where elt_account_number = " & elt_account_number & " and UPPER(dba_name) = N'" & UCase(tmpS) &"'"

Set rs = eltConn.execute (SQL)
if NOT rs.eof and NOT rs.bof then
	 vAnotherAccount = elt_account_number
	 vDbaName = rs("dba_name")
	 vTaxId = rs("business_fed_taxid")
	 vAddress = rs("business_address")
	 vCity = rs("business_city")
	 vState = rs("business_state")
	 vZip = rs("business_zip")
	 vCountry = rs("b_country_code")
	 vFirstName = rs("owner_fname")
	 vMiddleName = rs("owner_mname")
	 vLastName = rs("owner_lname")
	 vPhone = rs("business_phone")
	 vFax = rs("business_fax")
	 vCell = rs("owner_phone")
	 vEmail = rs("owner_email")
	 
	 oldConsignee = rs("is_consignee")	
	 oldShipper = rs("is_shipper")	
	 oldAgent = rs("is_agent")	
	 oldCarrier = rs("is_carrier")	
	 oldTrucker = rs("z_is_trucker")	
	 oldWarehousing = rs("z_is_warehousing")	
	 oldCFS = rs("z_is_cfs")	
	 oldBroker = rs("z_is_broker")	
	 oldGovt = rs("z_is_govt")	
	 oldSpecial = rs("z_is_special")	
	 oldVendor = rs("is_vendor")	

else
	rs.Close
	SQL = "select elt_account_number,org_account_number, dba_name, business_fed_taxid,business_address,business_city, business_state,business_zip, b_country_code,business_phone,business_fax,owner_lname,owner_fname,owner_mname,owner_phone,owner_email,"_
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
& " from organization where left(elt_account_number,5) = " & MID(elt_account_number,1,5) & " AND UPPER(dba_name) = N'" & UCase(tmpS) &"%'"
	Set rs = eltConn.execute (SQL)
	if NOT rs.eof and NOT rs.bof then
		 vAnotherAccount = rs("elt_account_number")
		 vDbaName = rs("dba_name")
		 vAddress = rs("business_address")
		 vCity = rs("business_city")
		 vState = rs("business_state")
		 vZip = rs("business_zip")
		 vCountry = rs("b_country_code")
		 vFirstName = rs("owner_fname")
		 vMiddleName = rs("owner_mname")
		 vLastName = rs("owner_lname")
		 vPhone = rs("business_phone")
		 vFax = rs("business_fax")
		 vCell = rs("owner_phone")
		 vEmail = rs("owner_email")
		 
	 oldConsignee = rs("is_consignee")	
	 oldShipper = rs("is_shipper")	
	 oldAgent = rs("is_agent")	
	 oldCarrier = rs("is_carrier")	
	 oldTrucker = rs("z_is_trucker")	
	 oldWarehousing = rs("z_is_warehousing")	
	 oldCFS = rs("z_is_cfs")	
	 oldBroker = rs("z_is_broker")	
	 oldGovt = rs("z_is_govt")	
	 oldSpecial = rs("z_is_special")	
	 oldVendor = rs("is_vendor")	
		 
	else
		rs.Close
	SQL = "select elt_account_number,org_account_number, dba_name, business_fed_taxid,business_address,business_city, business_state,business_zip, b_country_code,business_phone,business_fax,owner_lname,owner_fname,owner_mname,owner_phone,owner_email,"_
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
& " from organization where UPPER(dba_name) = '" & UCase(tmpS) &"%'"
		Set rs = eltConn.execute (SQL)
		
		if NOT rs.eof and NOT rs.bof then
			 vAnotherAccount = rs("elt_account_number")		
			 vDbaName = rs("dba_name")
			 vTaxId=rs("business_fed_taxid")
			 vAddress = rs("business_address")
			 vCity = rs("business_city")
			 vState = rs("business_state")
			 vZip = rs("business_zip")
			 vCountry = rs("b_country_code")

	 oldConsignee = rs("is_consignee")	
	 oldShipper = rs("is_shipper")	
	 oldAgent = rs("is_agent")	
	 oldCarrier = rs("is_carrier")	
	 oldTrucker = rs("z_is_trucker")	
	 oldWarehousing = rs("z_is_warehousing")	
	 oldCFS = rs("z_is_cfs")	
	 oldBroker = rs("z_is_broker")	
	 oldGovt = rs("z_is_govt")	
	 oldSpecial = rs("z_is_special")	
	 oldVendor = rs("is_vendor")	

	'///////////////////////////////////////		 
	'		 vFirstName = rs("owner_fname")
	'		 vMiddleName = rs("owner_mname")
	'		 vLastName = rs("owner_lname")
	'		 vPhone = rs("business_phone")
	'		 vFax = rs("business_fax")
	'		 vCell = rs("owner_phone")
	'		 vEmail = rs("owner_email")
	'///////////////////////////////////////		 
		else
		 vAnotherAccount = "1"
		 vDbaName = s
		 vAddress = ""
		 vCity = ""
		 vState = ""
		 vZip = ""
		 vCountry = ""
		 vFirstName = ""
		 vMiddleName = ""
		 vLastName = ""
		 vPhone = ""
		 vFax = ""
		 vCell = ""
		 vEmail = ""
		end if	
	end if	
end if
	 rs.Close	 

	 chkConsignee = oldConsignee
	 chkShipper = oldShipper	
	 chkAgent = oldAgent
	 chkCarrier = oldCarrier
	 chkTrucker = oldTrucker	
	 chkWarehousing = oldWarehousing	
	 chkCFS = oldCFS	
	 chkBroker = oldBroker
	 chkGovt = oldGovt
	 chkSpecial = oldSpecial
	 chkVendor = oldVendor

		select case sType
			case "Customer" 
'				chkShipper = "Y"
'				chkConsignee = "Y"
'				chkAgent = "Y"
			case "Shipper" 
				chkShipper = "Y"
'				chkConsignee = "Y"
			case "Consignee"
'				chkShipper = "Y"
				chkConsignee = "Y"
			case "Notify"
'				chkShipper = "Y"
				chkConsignee = "Y"
			case "Agent" 
				chkAgent = "Y"
			case "Vendor"
				chkVendor = "Y"
		end select	 

end sub
%>

<%
sub get_country
DIM iCnt
SQL = "select count(*) as iCnt from country_code where elt_account_number = " & elt_account_number 

Set rs = eltConn.execute (SQL)
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
end sub
%>

<%
sub get_all_state

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
end sub
%>

<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
	<input type="hidden" name="oDabName"  value="<%= OriginalDbaName%>"/>
  <tr>
      <td height="32" align="left" valign="middle" class="pageheader"><% if NOT isExist then response.write ("Quick Add to Client" ) else response.write ("Update Client" ) end if %></td>
  </tr>
</table>
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0"bgcolor="#73beb6">
  <tr> 
    <td> 
     <form name=form1 method="post" action="AddClient.asp">
       <table width="100%" border="0" cellpadding="3" cellspacing="0" bordercolor="#73beb6" class="border1px">
          <tr bgcolor="D5E8CB"> 
              <td height="8" colspan="6" align="center" valign="top" bgcolor="#ccebed" class="bodyheader">
<% 'if NOT isPostBack and OriginalDanName = "" then %>
<% 'else %>			  
	<img src='../Images/left_arrow.gif' name="bNext" width="5" height="9" onClick="javascript:PrevNext(0);" style="cursor:hand">			  
	&nbsp;&nbsp;&nbsp;&nbsp;
	<img src='../Images/right_arrow.gif' name="bNext" width="5" height="9" onClick="javascript:PrevNext(1);" style="cursor:hand">			  
<% 'end if%></td>
          </tr>
		            <tr align="left" valign="middle" bgcolor="#73beb6"> 
            <td colspan="2" height="1" class="bodyheader"></td>
          </tr>
<!--
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">&nbsp;</td>
                      <td align="left" class="bodyheader"><%=strBizType%> information  </td>
                    </tr>
-->					
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">Name(DBA)</td>
                      <td align="left"><span class="bodyheader">
					  <% On Error Resume Next : %>
                        <input name="txtDbaName" id="txtDbaName"  value="<%= vDbaName%>" size="64" 
						<% if isExist then response.write ( "class='d_shorttextfield'" ) else response.write ( "class='shorttextfield'" ) end if %> <% if cLng(vAnotherAccount) = cLng(elt_account_number) then response.write ( "readonly='true'" ) end if %>>
                      </span></td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">Address</td>
                      <td align="left"><span class="bodyheader">
                        <input name="txtAddress" class="shorttextfield" id="txtAddress"  value="<%= vAddress%>" size="64">
                      </span></td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">City</td>
                      <td align="left"><span class="bodyheader">
                        <input name="txtCity" class="shorttextfield" id="txtCity"  value="<%= vCity%>" size="24">
                      </span></td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">State/Province</td>
                      <td align="left"><select Name="lstState" size="1" class="smallselect" style="WIDTH: 150px" onChange="javascript:lstStateChange(this)">
						<% for i=0 to aStateIndex-1 %>
				<option value="<%=aStateCode(i)%>" <%if vState=aStateCode(i) then response.write("selected")%>><%= aStateName(i) %></option>
	                    <% next %>
			                      </select></td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">Zip/Postal</td>
                      <td align="left"><input name="txtZip" class="shorttextfield" id="txtZip"  value="<%= vZip%>" size="20">                 </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">Country</td>
                      <td align="left"><select Name="lstCountry" size="1" class="smallselect" style="WIDTH: 150px">
						<option value='0'></option>
						<% for i=0 to aConIndex-1 %>
				<option value="<%=aCountryCodeArry(i)%>" <%if vCountry=aCountryCodeArry(i) then response.write("selected")%>><%= aCountryArry(i) %></option>
                    <% next %>
                      </select></td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader"></td>
                      <td align="left"><span class="bodyheader">Primary Contact Info</span></td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">Name</td>
                      <td align="left">
                        <table border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                            <tr>
                                <td class="bodycopy">
                                    First Name                                </td>
                                <td class="bodycopy">
                                    M.I.</td>
                                <td class="bodycopy">
                                    Last Name                                </td>
                            </tr>
                            <tr>
                                <td>
                               <input name="txtFirstName" type="text" id="txtFirstName" class="m_shorttextfield" style="width:70px;" value="<%= vFirstName%>"/></td>
                                <td>
                               <input name="txtMiddleName" type="text" id="txtMiddleName" class="m_shorttextfield" style="width:30px;" value="<%= vMiddleName%>"/></td>
                                <td>
                               <input name="txtLastName" type="text" id="txtLastName" class="m_shorttextfield" style="width:70px;" value="<%= vLastName%>"/></td>
                            </tr>
                        </table>					  </td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">Phone</td>
                      <td align="left"><input name="txtPhone" type="text" value="<%= vPhone%>" id="txtPhone" class="m_shorttextfield" style="width:175px;" /></td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">Fax</td>
                      <td align="left"><input name="txtFax" type="text" value="<%= vFax%>" id="txtFax" class="m_shorttextfield" style="width:175px;" /></td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">Cell</td>
                      <td align="left"><input name="txtCell" type="text" value="<%= vCell%>" id="txtCell" class="m_shorttextfield" style="width:175px;" /></td>
                    </tr>
          <tr align="left" valign="middle" bgcolor="f3f3f3"> 
            <td width="7%" height="22" align="right" bgcolor="f3f3f3" class="bodyheader">Email</td>
            <td width="67%" align="left"><input name="txtEmail" type="text" id="txtEmail" class="m_shorttextfield" value="<%= vEmail%>" style="width:175px;" /></td>
          </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">Tax ID/USPPI</td>
                      <td align="left"><span class="bodyheader">
                        <input name="txtTaxId" class="shorttextfield" id="txtTaxId"  value="<%= vTaxId%>" size="20" maxlength="16">
                      </span></td>
                    </tr>
		  <tr align="center" bgcolor="D5E8CB"> 
            <td height="20" colspan="6" valign="middle" bgcolor="#ccebed" class="bodycopy">
            <input type="button" class="bodycopy" id=Button2 style="WIDTH: 200px; BACKGROUND-COLOR: #f4f2e8" value='<% if NOT isExist then response.write("Add as a New Client") else  response.write("Update & Copy into Screen" ) end if %>' name="AddTo" onClick="javascript:addToClient();">
            <input type="button" class="bodycopy" id=Button3 style="WIDTH: 100px; BACKGROUND-COLOR: #f4f2e8" onClick="javascript:window.close();" value="Close" name="CloseMe">
            <input type="button" class="bodycopy" id=Button3 style="WIDTH: 100px; BACKGROUND-COLOR: #f4f2e8" onClick="javascript:ResetClient();" value="New" name="CloseMe"></td>
          </tr>
        </table>
<!--// Start of Biz. type --> 		
		<div id="wAdd" style="display: block; position: absolute; top: 127px; left: 290px; width: 128px; background-color: #FFFFFF; layer-background-color: #FFFFFF; border: 1px none #000000; height: 20;">
                   <table width="128" border="0" cellpadding="1" cellspacing="0" bordercolor="#D4D0C8" class="border1px">
                        <tr>
                          <td height="18" align="center" valign="middle" bgcolor="#ccebed" class="bodyheader">Business Type </td>
                        </tr>
                        <tr>
                          <td height="1" align="left" valign="middle" bgcolor="#666666" class="bodycopy"></td>
                        </tr>
                        <tr>
                            <td align="left" class="bodycopy" valign="middle">
                                <input id="chkConsignee" <% if chkConsignee <> oldConsignee then response.write("class='redinputbox'") else response.write("class='normalinputbox'") end if %> type="checkbox" name="chkConsignee" <% if chkConsignee="Y" or oldConsignee="Y" Then response.write("checked") %> onClick="javascript:cClick(this);"/><label for="chkConsignee">Consignee</label></td>
                        </tr>
                        <tr>
                            <td align="left" class="bodycopy" valign="middle">                                </td>
                        </tr>
                        <tr>
                          <td align="left" class="bodycopy" valign="middle"><input id="chkShipper" <% if chkShipper <> oldShipper then response.write("class='redinputbox'") else response.write("class='normalinputbox'") end if %> type="checkbox" name="chkShipper" <% if chkShipper="Y" or oldShipper="Y" Then response.write("checked") %> onClick="javascript:cClick(this);"/><label for="chkShipper">Shipper</label></td>
                        </tr>
                        <tr>
                            <td align="left" class="bodycopy" valign="middle"><input id="chkAgent" <% if chkAgent <> oldAgent then response.write("class='redinputbox'") else response.write("class='normalinputbox'") end if %> type="checkbox" name="chkAgent" <% if chkAgent="Y" or oldAgent="Y" Then response.write("checked") %> onClick="javascript:cClick(this);"/><label for="chkAgent">Agent</label></td>
                        </tr>
                        <tr>
                            <td align="left" class="bodycopy" style="height: 20px" valign="middle"><input id="chkCarrier" <% if chkCarrier <> oldCarrier then response.write("class='redinputbox'") else response.write("class='normalinputbox'") end if %> type="checkbox" name="chkCarrier" <% if chkCarrier="Y" or oldCarrier="Y" Then response.write("checked") %> onClick="javascript:cClick(this);"/><label for="chkCarrier">Carrier</label>                                </td>
                        </tr>
                        <tr>
                            <td align="left" class="bodycopy" style="height: 20px" valign="middle"><input id="chkTrucker" <% if chkTrucker <> oldTrucker then response.write("class='redinputbox'") else response.write("class='normalinputbox'") end if %> type="checkbox" name="chkTrucker" <% if chkTrucker="Y"  or oldTrucker="Y" Then response.write("checked") %> onClick="javascript:cClick(this);"/><label for="chkTrucker">Trucker</label>                                </td>
                        </tr>
                        <tr>
                          <td align="left" class="bodycopy" style="height: 20px" valign="middle"><input id="chkWarehousing" <% if chkWarehousing <> oldWarehousing then response.write("class='redinputbox'") else response.write("class='normalinputbox'") end if %> type="checkbox" name="chkWarehousing" <% if chkWarehousing="Y"  or oldWarehousing="Y" Then response.write("checked") %> onClick="javascript:cClick(this);"/><label for="chkWarehousing">Warehouse</label></td>
                        </tr>
                        <tr>
                          <td align="left" class="bodycopy" style="height: 20px" valign="middle"><input id="chkCFS" type="checkbox" <% if chkCFS <> oldCFS then response.write("class='redinputbox'") else response.write("class='normalinputbox'") end if %> name="chkCFS" <% if chkCFS="Y" or oldCFS="Y" Then response.write("checked") %> onClick="javascript:cClick(this);"/><label for="chkCFS">Terminal/CFS</label></td>
                        </tr>
                        <tr>
                          <td align="left" class="bodycopy" style="height: 20px" valign="middle"><input id="chkBroker" <% if chkBroker <> oldBroker then response.write("class='redinputbox'") else response.write("class='normalinputbox'") end if %> type="checkbox" name="chkBroker" <% if chkBroker="Y" or oldBroker="Y" Then response.write("checked") %> onClick="javascript:cClick(this);"/><label for="chkBroker">CHB</label></td>
                        </tr>
                        <tr>
                          <td align="left" class="bodycopy" style="height: 20px" valign="middle"><input id="chkGovt" <% if chkGovt <> oldGovt then response.write("class='redinputbox'") else response.write("class='normalinputbox'") end if %> type="checkbox" name="chkGovt" <% if chkGovt="Y" or oldGovt="Y" Then response.write("checked") %> onClick="javascript:cClick(this);"/><label for="chkGovt">Gov't</label></td>
                        </tr>
                        <tr>
                          <td align="left" class="bodycopy" style="height: 20px" valign="middle"><input id="chkVendor" <% if chkVendor <> oldVendor then response.write("class='redinputbox'") else response.write("class='normalinputbox'") end if %> type="checkbox" name="chkVendor" <% if chkVendor="Y" or oldVendor="Y" Then response.write("checked") %> onClick="javascript:cClick(this);"/><label for="chkVendor">Vendor</label></td>
                        </tr>		
                        <tr>
                          <td align="left" class="bodycopy" style="height: 20px" valign="middle"><input id="chkSpecial" <% if chkSpecial <> oldSpecial then response.write("class='redinputbox'") else response.write("class='normalinputbox'") end if %> type="checkbox" name="chkSpecial" <% if chkSpecial="Y" or oldSpecial="Y" Then response.write("checked") %> onClick="javascript:cClick(this);"/><label for="chkSpecial">Other</label></td>
                        </tr>																
          </table>		
		</div>			
<!--// End of Biz. type --> 				
      </form></td>
  </tr>
</table>
</body>

<script language="javascript">
function cClick(o) {
if(o.checked) 
{
	o.value = 'Y';
}
else
{
	o.value = '';
}

}
function PrevNext(i) 
{

var strDbaName = document.all.txtDbaName.value;	

	if(trim(strDbaName) == "" )
	{
//		return;
	}

var strAction 
if (i) 	
{ 
	strAction = 'next'
}
else
{
	strAction = 'prev'
}	
	document.form1.action="AddClient.asp?Action="+strAction+"&Type="+"<%=sType%>"+"&WindowName="+window.name;
	document.form1.method="POST";
	document.form1.target = window.name;
	document.form1.submit();

}

function trim(sourceString) { return sourceString.replace(/(?:^\s+|\s+$)/ig, ""); }

function ResetClient() {
	
	document.form1.action="AddClient.asp?Action=reset&Type="+"<%=sType%>"+"&WindowName="+window.name;
	document.form1.method="POST";
	document.form1.target = window.name;
	document.form1.submit();
}
function addToClient() {
//	var strEmail = document.all.txtEmail.value;
//	if(trim(strEmail) != "" )
//	{
//		if(!validateEmail(strEmail)) {
//			alert('Please enter a valid email address');
//			document.all.txtEmail.focus();
//			return;
//		}
//	}
var strDbaName = document.all.txtDbaName.value;	

	if(trim(strDbaName) == "" )
	{
		alert('Please enter a Company name!');
		document.all.txtDbaName.focus();
		return;
	}
	var orDab_name = document.all.oDabName.value;
	var postBack = '<%=PostBack%>';

	if(trim(orDab_name) == "" && postBack.toLowerCase() == "false") {
		if( !CHECK_ORGANIZATION_AJAX(strDbaName) )
		{
			while(strDbaName.indexOf("&") != -1) { strDbaName = strDbaName.replace('&','________');	}	
			while(strDbaName.indexOf("'") != -1) { strDbaName = strDbaName.replace("'","^^^^^^^^");	}				
			var param =  'PostBack=false&Type='+'<%=sType%>'+'&s=' + encodeURIComponent(strDbaName); 
			document.form1.action="AddClient.asp?"+param;
			document.form1.method="POST";
			document.form1.target = window.name;
			document.form1.submit();
			return true;
		}
	}
		document.form1.action="AddClient.asp?Action=save&Type="+"<%=sType%>"+"&WindowName="+window.name;
		document.form1.method="POST";
		document.form1.target = window.name;
		document.form1.submit();
}

function validateEmail(emailad) {
var exclude=/[^@\-\.\w]|^[_@\.\-]|[\._\-]{2}|[@\.]{2}|(@)[^@]*\1/;
var check=/@[\w\-]+\./;
var checkend=/\.[a-zA-Z]{2,3}$/;
if(((emailad.search(exclude) != -1)||(emailad.search(check)) == -1)||(emailad.search(checkend) == -1)){
	return false;
}
return true;
}
</script>
</html>
