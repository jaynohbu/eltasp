<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/AspFunctions.inc" -->
<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>

<%
	'if not check_url("IFF_MAIN") then 
		'response.write "e"
		'response.end
	'end if
%>

<%
DIM elt_account_number,org,arrival_notice

org = Request.QueryString("org")
if isnull(org) then org = ""
if org = ""  then
	response.end
end If

elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")


Dim typeValue
typeValue = Request.QueryString("type").Item

If IsNull(typeValue) Then
    call get_org_info(org)
Else
    If typeValue = "B" Then 
        Call get_org_name_address(org)
    Elseif typeValue = "DB" Then
        Call get_default_broker(org)
    Elseif typeValue = "C" Then
        Call get_org_cCode_name_address(org)
    Elseif typeValue = "D" Then
        Call get_org_tel_fax(org)
    Elseif typeValue = "N" Then
        Call get_org_address_with_broker_for_ar(org)
    Elseif typeValue = "ARN" Then
        Call get_org_address_for_ar(org)
    Elseif typeValue = "IV" Then
        Call get_org_address_for_iv(org)
    Elseif typeValue = "check" Then
        Call get_org_address_for_check(org)
    Elseif typeValue = "sed_s" Then
        Call get_org_address_for_sed(org,"1")
    Elseif typeValue = "sed_c" Then
        Call get_org_address_for_sed(org,"2")
    Elseif typeValue = "invTerm" Then
        Call get_org_inv_term(org)
    Else
        Call get_org_info(org)
    End If
End If

%>

<%
    Sub get_org_inv_term(orgNum)
        Dim rs, SQL, resVal
        resVal = 0
        SQL = "SELECT bill_term FROM organization WHERE elt_account_number=" & elt_account_number _
            & " AND org_account_number=" & orgNum
	    Set rs = Server.CreateObject("ADODB.Recordset")
	    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
        If Not rs.EOF Then
            resVal = rs("bill_term").value
        End If
        rs.Close()
        Set rs = Nothing
        Response.Write resVal
    End Sub
%>

<%
Sub get_org_info( org )

    Dim rs, SQL    
	Dim AddressInfo,cAcct,cCity,cState,cZip,cCountry,cPhone,cAddress,cName
	
    set rs=Server.CreateObject("ADODB.Recordset")
	
    if org = "" then Exit sub

    SQL= "select dba_name,org_account_number,business_address,business_city,business_State,business_Zip,business_Country,business_phone,is_agent,is_shipper,is_consignee from organization where elt_account_number = " & elt_account_number & " and org_account_number ="&org
    
	    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
    	
	    If Not rs.EOF Then
			cName=rs("dba_name")
			cAcct=rs("org_account_number")
			cAddress=rs("business_address")
			cCity=rs("business_city")
			cState=rs("business_State")
			cZip=rs("business_Zip")
			cCountry=rs("business_Country")
			cPhone=rs("business_phone")
			if Not Trim(cState)="" then
				AddressInfo=cAcct & "-" & cName & chr(10) & cAddress & chr(10) & cCity & "," & cState _
				    & " " & cZip & "," & cCountry '// & chr(10) & cPhone

			else
		       If Trim(cZip)<>"" Then
			        AddressInfo = cAcct & "-" & cName & chr(10) & cAddress & chr(10) & cCity & " " _
			            & cZip & " " & cCountry '// & chr(10) & cPhone
			    Else
			        AddressInfo = cAcct & "-" & cName & chr(10) & cAddress & chr(10) & cCity & "," _
			            & cCountry '// & chr(10) & cPhone
			    End If
			end if
			
		     If rs("is_consignee") ="Y" And Trim(cPhone)<>"" Then
		        AddressInfo = AddressInfo & chr(10) & "TEL: " & cPhone
		    Elseif Trim(cPhone)<>"" Then
		    Else
		        AddressInfo = AddressInfo & chr(10) & cPhone
		    End If
		End If
	    rs.close
		set rs=nothing 
		response.write AddressInfo
End sub


Sub get_default_broker(vOrg)
    Dim rs, SQL, vDefaultBorkerInfo  
	
    set rs=Server.CreateObject("ADODB.Recordset")
	vDefaultBorkerInfo = ""
	
    If vOrg <> "" Then
        SQL = "select broker_info FROM organization WHERE elt_account_number=" _
            & elt_account_number & " AND org_account_number=" & org
        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
        
        If Not rs.EOF Then
            vDefaultBorkerInfo = rs("broker_info").value
        End If
        
        rs.close
        set rs = nothing 
    End If
    
	response.write vDefaultBorkerInfo
	
End Sub

'// Added by Joon on Mar/05/2007
'///////////////////////////////////////////////////////////////////////////////////

Sub get_org_name_address(org)
    Dim tempInfo,SQL,rs
    
    Set rs = Server.CreateObject("ADODB.Recordset")
    
    SQL = "select isnull(dba_name,'') as dba_name,isnull(business_address,'') as business_address" _
        & ",isnull(business_city,'') as business_city,isnull(business_state,'') as business_state" _
        & ",isnull(business_zip,'') as business_zip,isnull(business_country,'') as business_country" _
        & ",isnull(business_phone,'') as business_phone,isnull(business_fax,'') as business_fax" _
        & ",is_shipper,org_account_number,isnull(' - ' + class_code,'') as class_code" _
        & ",isnull(char(13) + CAST(business_address2 AS NVARCHAR(1024)),'') as business_address2" _
        & " FROM organization where elt_account_number=" & elt_account_number _
		& " AND org_account_number=" & org
    
    eltConn.CursorLocation = adUseClient
	rs.CursorLocation = adUseClient	
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
    Set rs.ActiveConnection = Nothing

    If Not rs.EOF And Not rs.bof Then
		
		If rs("business_State").value = "" Then
			tempInfo =  rs("DBA_NAME").value & chr(10) & rs("business_address").value _
			    & rs("business_address2").value & chr(10) & rs("business_city").value _
			    & " " & rs("business_Zip").value _
				& "," & rs("business_Country").value & chr(10) 
		Else
            tempInfo = rs("DBA_NAME").value _
				& chr(10) & rs("business_address").value & rs("business_address2").value _
				& chr(10) & rs("business_city").value _
				& "," & rs("business_State").value & " " & rs("business_Zip").value _
				& "," & rs("business_Country").value & chr(10) 
		End If
		
		If Not IsNull(rs("business_phone").value) And Trim(rs("business_phone").value) <> "" Then
	        tempInfo = tempInfo & "Tel:" & rs("business_phone").value & " "
	    End If
	    
	    If Not IsNull(rs("business_fax").value) And Trim(rs("business_fax").value) <> "" Then
	        tempInfo = tempInfo & "Fax:" & rs("business_fax").value & " "
	    End If
		
	End If
    
    rs.Close
	Set rs = Nothing
    response.write formatSQLString(tempInfo)
    
End Sub

Sub get_org_cCode_name_address(org)
    Dim tempInfo,SQL,rs
    
    Set rs = Server.CreateObject("ADODB.Recordset")
    
    SQL = "select isnull(dba_name,'') as dba_name,isnull(business_address,'') as business_address" _
        & ",isnull(business_city,'') as business_city,isnull(business_state,'') as business_state" _
        & ",isnull(business_zip,'') as business_zip,isnull(business_country,'') as business_country" _
        & ",isnull(business_phone,'') as business_phone,isnull(business_fax,'') as business_fax" _
        & ",is_shipper,org_account_number,isnull(' - ' + class_code,'') as class_code" _
        & ",isnull(char(13) + CAST(business_address2 AS NVARCHAR(1024)),'') as business_address2" _
        & ",isnull(carrier_code,'') as carrier_code" _
        & " FROM organization where elt_account_number=" & elt_account_number _
		& " AND org_account_number=" & org
    
    eltConn.CursorLocation = adUseClient
	rs.CursorLocation = adUseClient	
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
    Set rs.ActiveConnection = Nothing

    If Not rs.EOF And Not rs.bof Then
		
		If rs("business_State").value = "" Then
			tempInfo =  rs("carrier_code").value & "-" _
			    & rs("DBA_NAME").value & chr(10) & rs("business_address").value _
			    & rs("business_address2").value & chr(10) & rs("business_city").value _
				& "," & rs("business_Country").value & chr(10) 
		Else
            tempInfo = rs("carrier_code").value & "-" & rs("DBA_NAME").value _
				& chr(10) & rs("business_address").value & rs("business_address2").value _
				& chr(10) & rs("business_city").value _
				& "," & rs("business_State").value & " " & rs("business_Zip").value _
				& "," & rs("business_Country").value & chr(10) 
		End If
		
		If Not IsNull(rs("business_phone").value) And Trim(rs("business_phone").value) <> "" Then
	        tempInfo = tempInfo & "Tel:" & rs("business_phone").value & " "
	    End If
	    
	    If Not IsNull(rs("business_fax").value) And Trim(rs("business_fax").value) <> "" Then
	        tempInfo = tempInfo & "Fax:" & rs("business_fax").value & " "
	    End If
		
	End If
    
    rs.Close
	Set rs = Nothing
    response.write formatSQLString(tempInfo)
End Sub

Function formatSQLString(arg)
    Dim temp
    If IsNull(arg) Or Trim(arg) = "" Then
        temp = ""
    Else
        temp = Replace(arg,chr(34)," ")
        temp = Replace(temp,chr(39),"`")
    End If
    formatSQLString = temp
End Function

%>

<%
Sub get_org_address_with_broker_for_ar( org )
    Dim rs, SQL    
	Dim AddressInfo, cState
	
    set rs=Server.CreateObject("ADODB.Recordset")
	
    if org = "" then Exit sub

    SQL= "select dba_name,org_account_number,business_address,business_city,business_State,business_Zip,business_Country,business_phone,business_fax,broker_info from organization where elt_account_number = " & elt_account_number & " and org_account_number ="&org
    
	    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
    	
	    If Not rs.EOF Then
    	cState= rs("business_State")
	    if Not Trim(cState)="" then
		    AddressInfo=rs("org_account_number") & "-" & rs("dba_name") & chr(10) & rs("business_address") & chr(10) & rs("business_city") & "," & rs("business_State") & " " & rs("business_Zip") & "," & rs("business_Country") & chr(10) & "Tel:" & rs("business_phone") & " " & "Fax:" & rs("business_fax")
	    else
		    AddressInfo=rs("org_account_number") & "-" & rs("dba_name") & chr(10) & rs("business_address") & chr(10) & rs("business_city") & "," & rs("business_Country") & chr(10) & "Tel:" & rs("business_phone") & " " & "Fax:" & rs("business_fax")
	    end If

	    AddressInfo = AddressInfo & "@@@" & rs("broker_info")

	End If
	rs.close
	set rs=nothing 
	response.write AddressInfo

End sub
%>

<%
Sub get_org_address_for_ar( org )
    Dim rs, SQL    
	Dim AddressInfo, cState
	
    set rs=Server.CreateObject("ADODB.Recordset")
	
    if org = "" then Exit sub

    SQL= "select dba_name,org_account_number,business_address,business_city,business_State,business_Zip,business_Country,business_phone,business_fax from organization where elt_account_number = " & elt_account_number & " and org_account_number ="&org
	
    rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
    	
	    If Not rs.EOF Then
    	cState= rs("business_State")
	    if Not Trim(cState)="" then
		    AddressInfo=rs("org_account_number") & "-" & rs("dba_name") & chr(10) & rs("business_address") & chr(10) & rs("business_city") & "," & rs("business_State") & " " & rs("business_Zip") & "," & rs("business_Country") & chr(10) & "Tel:" & rs("business_phone") & " " & "Fax:" & rs("business_fax")
	    else
		    AddressInfo=rs("org_account_number") & "-" & rs("dba_name") & chr(10) & rs("business_address") & chr(10) & rs("business_city") & "," & rs("business_Country") & chr(10) & "Tel:" & rs("business_phone") & " " & "Fax:" & rs("business_fax")
	    end If

	End If
	rs.close
	set rs=nothing 

End sub
%>

<%
Sub get_org_address_for_iv( org )

Dim rs, SQL    
Dim cName,cAcct,cAddress,cAddress2,cCity,cState,cZip,cCountry,cPhone,cFax,cZAttn,AddressInfo

set rs=Server.CreateObject("ADODB.Recordset")

if org = "" then Exit sub

SQL= "select DBA_NAME,org_account_number,isnull(business_address,'') as business_address,isnull(business_address2,'') as "&_
	 "business_address2,isnull(business_city,'') as business_city,isnull(business_State,'') as business_State,isnull(business_zip,'') as business_zip,isnull(business_country,'') as business_country,"&_
	 "isnull(owner_mail_address,'') as owner_mail_address,isnull(owner_mail_address2,'') as owner_mail_address2,"&_
	 "owner_mail_city,isnull(owner_mail_state,'') as owner_mail_state,isnull(owner_mail_zip,'') as owner_mail_zip,isnull(owner_mail_country,'') as owner_mail_country,isnull(business_phone,'') as business_phone,isnull(business_fax,'') as business_fax,isnull(z_attn_txt,'') as z_attn_txt from organization where elt_account_number = "&_ 
	 elt_account_number & " and org_account_number ="&org


	rs.CursorLocation = adUseClient
	rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
	Set rs.activeConnection = Nothing

if Not rs.EOF then
	cName = rs("DBA_NAME")
	cAcct=cLng(rs("org_account_number"))

	cAddress = rs("owner_mail_address")
	If Trim(cAddress) = "" Then
		cAddress = rs("business_address")			
	End If 

	cAddress2 = rs("owner_mail_address2")
	If Trim(cAddress2) = "" Then
		cAddress2 = rs("business_address2")			
	End If 

	cCity = rs("owner_mail_city")
	If Trim(cCity) = "" Then
		cCity = rs("business_city")			
	End If 

	cState = rs("owner_mail_state")
	If Trim(cState) = "" Then
		cState = rs("business_State")
	End If 

	cZip = rs("owner_mail_zip")
	If Trim(cZip) = "" Then
		cZip = rs("business_zip")
	End If 

	cCountry = rs("owner_mail_country")
	If Trim(cCountry) = "" Then
		cCountry = rs("business_country")
	End If
	

	cPhone = rs("business_phone")
	cFax=rs("business_fax")

	cZAttn=rs("z_attn_txt")

	if Trim(cZAttn) = "" or isnull(rs("z_attn_txt")) then
		cZAttn = "ATTN.: Accounts Payable"
	else
		cZAttn = "ATTN.:"& cZAttn
	end if
	Dim tmpAdd2

	if trim(cAddress2) <> "" then
		tmpAdd2 = cAddress2 & chr(10)
	else
		tmpAdd2 = ""
	end if

	if trim(cCity) <> "" then
		cCity = cCity
	else
		cCity = ""
	end if

	if trim(cCountry) <> "" then
		cCountry = cCountry & chr(10)
	else
		cCountry = ""& chr(10)
	end if

	if trim(cZip) <> "" then
		cZip = cZip & ","
	else
		cZip = ""
	end if

	if trim(cState) <> "" then
		cState = "," & cState 
	else
		cState = ""
	end if

	if trim(cPhone) <> "" then
		cPhone = "Tel: " & cPhone
	else
		cPhone = ""
	end if

	if trim(cFax) <> "" then
		cFax = "  Fax: " & cFax
	else
		cFax = ""
	end if

	AddressInfo=cAcct & "-" & cName & chr(10)  & cZAttn & chr(10) & cAddress & chr(10) & tmpAdd2 & cCity  & cState & " " & cZip & cCountry & cPhone & cFax
	AddressInfo = Replace(AddressInfo,"Select One","")
	AddressInfo = Replace(AddressInfo,"Tel:  ","")
	AddressInfo = Replace(AddressInfo,"Fax:  ","")
	AddressInfo = Replace(AddressInfo,",    "," ")
	AddressInfo = Replace(AddressInfo,",   "," ")
	AddressInfo = Replace(AddressInfo,",  "," ")
	AddressInfo = Replace(AddressInfo,", "," ")
	AddressInfo = Replace(AddressInfo,","&chr(10),chr(10))
	AddressInfo = Replace(AddressInfo,chr(10)&" ",chr(10))
end if
rs.Close

response.write AddressInfo

End sub
%>

<%
Sub get_org_address_for_check( org )

Dim rs, SQL    
Dim Address,Address2,City,State,Zip,Country,AddressStr,tmpAdd2

if org = "" then Exit sub
set rs=Server.CreateObject("ADODB.Recordset")

'get vendor info
SQL= "select * from organization where elt_account_number=" & elt_account_number & " and (Is_Agent='Y' or Is_Vendor='Y' or z_is_special ='Y' or z_is_trucker='Y')   and org_account_number="&org

rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing

'DIM AddressStr
	if Not rs.EOF then

		AddressStr = ""

		Address=rs("business_address").Value
		Address2=rs("business_address2").Value

		if trim(Address2) <> "" then
			tmpAdd2 = Address2 & chr(10)
		else
			tmpAdd2 = ""
		end if

		City=rs("business_city").Value
		State=rs("business_State").Value
		Zip=rs("business_zip").Value
		Country=rs("business_country").Value
		

		Address = rs("dba_name").Value & chr(10) & Address & chr(10) & tmpAdd2 & City & "," & State & " " & Zip & chr(10) & Country

		if NOT isnull(rs("print_check_as_info").Value) then
			if trim(rs("print_check_as_info").Value) <> "" then
				AddressStr = rs("org_account_number").Value & "-" &rs("print_check_as_info").Value
			else
				AddressStr = rs("org_account_number").Value & "-" & Address
			end if
		else
				AddressStr = rs("org_account_number").Value & "-" & Address
		end if

		if AddressStr = "" then
			AddressStr = rs("org_account_number").Value & "-" & Address
		end if
		
		if NOT isnull(rs("print_check_as").Value) then
			if trim(rs("print_check_as").Value) <> "" then
				AddressStr = AddressStr & "@@@" & rs("print_check_as").Value 
			else
				AddressStr = AddressStr & "@@@" & rs("dba_name").Value 
			end if
		else
				AddressStr = AddressStr & "@@@" & rs("dba_name").Value 
		end if
	end if
	rs.Close

	AddressStr = Replace(AddressStr,"Select One","")
	AddressStr = Replace(AddressStr,",    "," ")
	AddressStr = Replace(AddressStr,",   "," ")
	AddressStr = Replace(AddressStr,",  "," ")
	AddressStr = Replace(AddressStr,", "," ")
	AddressStr = Replace(AddressStr,","&chr(10),chr(10))

	response.write AddressStr
End sub
%>

<%
Sub get_org_address_for_sed( org, sType )

Dim rs, SQL    
Dim cName,cAcct,cTaxID,cAddress,cCity,cState,cZip,cCountry,cCountryCode,cPhone,cContactLastName,cContactFirstName,IsShipper,IsConsignee,AddressInfo
if org = "" then Exit sub
set rs=Server.CreateObject("ADODB.Recordset")

SQL= "select * from organization where elt_account_number=" & elt_account_number & " and org_account_number="&org

rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing

if not rs.eof then

	cName = rs("DBA_NAME")
	cAcct=cLng(rs("org_account_number"))
	cTaxID=rs("business_fed_taxid")
	cAddress = rs("business_address")
	cCity = rs("business_city")
	cState = rs("business_State")
	cZip = rs("business_Zip")
	cCountry = rs("business_country")
	cCountryCode=rs("b_country_code")
	cPhone = rs("business_phone")
	cContactLastName=rs("owner_lname")
	cContactFirstName=rs("owner_fname")

	if sType="1" then
		AddressInfo= cName & "@@@" & cAcct & chr(10) & cTaxID & chr(10) & cContactLastName & chr(10) & cContactFirstName & chr(10) & cName & chr(10) & cAddress & chr(10) & cCity & "," & cState & " " & cZip & "," & cCountry & chr(10) & cPhone 
	else
		AddressInfo= cName & "@@@" & cCountryCode & "-" & cAcct & "-" & cName & chr(10) & cAddress & chr(10) & cCity & "," & cState & " " & cZip & "," & cCountry & chr(10) & cPhone
	end if

end if
rs.Close
response.write AddressInfo
End sub
%>

<%

Sub get_org_tel_fax(org)
    Dim tempInfo,SQL,rs
    
    Set rs = Server.CreateObject("ADODB.Recordset")
    tempInfo = ""
    
    SQL = "select isnull(business_phone,'') as business_phone,isnull(business_fax,'') as business_fax" _
        & ",is_shipper,org_account_number,isnull(' - ' + class_code,'') as class_code" _
        & ",isnull(char(13) + CAST(business_address2 AS NVARCHAR(1024)),'') as business_address2" _
        & " FROM organization where elt_account_number=" & elt_account_number _
		& " AND org_account_number=" & org
    
    eltConn.CursorLocation = adUseClient
	rs.CursorLocation = adUseClient	
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
    Set rs.ActiveConnection = Nothing

    If Not rs.EOF And Not rs.bof Then

		If Not IsNull(rs("business_phone").value) And Trim(rs("business_phone").value) <> "" Then
	        tempInfo = tempInfo & "Tel:" & rs("business_phone").value & " "
	    End If
	    
	    If Not IsNull(rs("business_fax").value) And Trim(rs("business_fax").value) <> "" Then
	        tempInfo = tempInfo & "Fax:" & rs("business_fax").value & " "
	    End If
		
	End If
    
    rs.Close
	Set rs = Nothing
    response.write formatSQLString(tempInfo)
    
End Sub
%>