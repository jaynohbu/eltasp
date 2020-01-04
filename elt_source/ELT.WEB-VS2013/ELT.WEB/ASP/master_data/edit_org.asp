<!--  #INCLUDE FILE="../include/transaction.txt" -->
<!--  #INCLUDE FILE="../include/connection.asp" -->
<html>

<head>
<meta http-equiv="Content-Language" content="en-us">
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<title>Edit Organization</title>
</head>

<!--  #INCLUDE FILE="../include/header.asp" -->
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #INCLUDE file="../include/CountryStates.asp" -->


<%
Dim rs, SQL
Set rs = Server.CreateObject("ADODB.Recordset")

Dim OrgID
OrgID=CInt(Request.QueryString("OrgID"))
if OrgID="" then OrgID=0
AddOrg=Request.QueryString("AddOrg")
UpdateOrg=Request.QueryString("UpdateOrg")
EditOrg=Request.QueryString("EditOrg")
DeleteOrg=Request.QueryString("DeleteOrg")
AutoCreate=Request.QueryString("AutoCreate")

Dim SelectedBname
Dim vDBA,vBname,vTaxID,vBaddress,vBcity,vBstate,vBzip,vBcountry,vBurl,vBphone,vBfax
Dim vCFname,vCLname,vCphone,vCaddress,vCcity,vCstate,vCzip,vCcountry,vCemail
Dim IsShipper,IsConsignee,IsAgent,IsVendor,IsCarrier,vComment
Dim vCarrierCode,vCarrierID
vAccountStatus="A"
if AddOrg="yes" or UpdateOrg="yes" then
elseif AutoCreate="yes" then
	vHAWB=Request("HAWB_NUM")
	SQL= "select consignee_info from import_hawb where elt_account_number = " & elt_account_number & " and hawb_num='" & vHAWB & "'"
	rs.Open SQL, eltConn, , , adCmdText
	If Not rs.EOF Then
		ConsigneeInfo=rs("consignee_info")
		pos=0
		pos=instr(ConsigneeInfo,chr(10))
		if pos>0 then
			vDBA=Mid(ConsigneeInfo,1,pos-1)
			vBName=vDBA
			ConsigneeInfo=Mid(ConsigneeInfo,pos+1,200)
		end if
		pos=0
		pos=instr(ConsigneeInfo,chr(10))
		if pos>0 then
			ConsigneeInfo=Mid(ConsigneeInfo,pos+1,200)
		end if
		pos=instr(ConsigneeInfo,chr(10))
		if pos>0 then
			vBAddress=Mid(ConsigneeInfo,1,pos-1)
			ConsigneeInfo=Mid(ConsigneeInfo,pos+1,200)
		end if
		pos=0
		pos=instr(ConsigneeInfo,",")
		if pos>0 then
			vBCity=Mid(ConsigneeInfo,1,pos-1)
			ConsigneeInfo=Mid(ConsigneeInfo,pos+1,200)
		end if
		pos=0
		pos=instr(ConsigneeInfo,",")
		if pos>0 then
			vBState=Mid(ConsigneeInfo,1,pos-1)
			ConsigneeInfo=Mid(ConsigneeInfo,pos+1,200)
		end if
		pos=0
		pos=instr(ConsigneeInfo,",")
		if pos>0 then
			vBCountry=Mid(ConsigneeInfo,1,pos-1)
			ConsigneeInfo=Mid(ConsigneeInfo,pos+1,200)
		end if
	End If
	rs.Close
end if

Dim OrgACCT(10000),DBAname(10000),aAllOrgInfo(10000)
tIndex=0
aIndex=0
cIndex=0
sIndex=0
vIndex=0
nIndex=0
DL="#@"
SQL= "select * from organization where elt_account_number = " & elt_account_number & " order by dba_name"
rs.Open SQL, eltConn, , , adCmdText
Do While Not rs.EOF 
	cName=rs("DBA_NAME")
	cAcct=cLng(rs("org_account_number"))
	cAddress=rs("business_address")
	cCity=rs("business_city")
	cState=rs("business_State")
	cZip=rs("business_Zip")
	cCountry=rs("business_Country")
	cPhone=rs("business_phone")
	IIsAgent=rs("is_agent")
	IIsShipper=rs("is_shipper")
	IIsConsignee=rs("is_consignee")
	IIsVendor=rs("is_vendor")
	if Not Trim(cState)="" then
		AddressInfo=cAcct & DL & IIsAgent & DL & IIsConsignee & DL & IIsShipper & DL & IIsVendor & DL & cName & DL & cAddress & DL & cCity & "," & cState & " " & cZip & "," & cCountry & DL & cPhone
	else
		AddressInfo=cAcct & IIsAgent & DL & IIsConsignee & DL & IIsShipper & DL & IIsVendor & DL & cName & DL & cAddress & DL & cCity & "," & cCountry & DL & cPhone
	end if
	OrgAcct(tIndex)=cAcct
	DBAname(tIndex)=cName
	aAllOrgInfo(tIndex)=AddressInfo
	tIndex=tIndex+1
	rs.MoveNext
Loop
rs.Close
'get colodee info
SQL= "select * from colo where coloder_elt_acct = " & elt_account_number & " order by colodee_name"
rs.Open SQL, eltConn, , , adCmdText
Dim aColodeeName(32),aColodeeAcct(32)
coIndex=1
aColodeeName(0)="Select One"
aColodeeAcct(0)=0
Do While Not rs.EOF
	aColodeeName(coIndex)=rs("colodee_name")
	aColodeeAcct(coIndex)=cLng(rs("colodee_elt_acct"))
	coIndex=coIndex+1
	rs.MoveNext
Loop
rs.Close
'get country code
Dim aCountry(256),aCountryCode(256)
SQL= "select * from country_code where elt_account_number=" & elt_account_number & " order by country_name"
rs.Open SQL, eltConn, , , adCmdText
cyIndex=1
aCountry(0)="Select One"
aCountryCode(0)=""
Do While Not rs.EOF
	aCountry(cyIndex)=rs("country_name")
	aCountryCode(cyIndex)=rs("country_code")
	cyIndex=cyIndex+1
	rs.MoveNext
Loop
rs.Close
Set rs=Nothing
%>

<body>

<table border="0" width="100%">
  <tr>
    <td width="100%">&nbsp;</td>
  </tr>
  <tr>
    <td width="100%">
      <form name=form1 action="edit_org.asp" method="POST" webbot-action="--WEBBOT-SELF--">
<input type=hidden id="AllOrgInfo">
<% for i=0 to tIndex-1 %>
<input type=hidden id="AllOrgInfo" value="<%= aAllOrgInfo(i) %>">
<% next %>

		<input type="hidden" name="hNoItem" value="<%= tIndex %>">
        <table border="1" cellpadding="0" cellspacing="0" width="100%" bordercolor="#f8d5b6">
          <tr>
            <td width="100%">
              <table border="0" cellpadding="0" cellspacing="0" width="100%" bgcolor="#fdeee1">
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="30%" align="right">
                    <p align="left"><b><font size="4">Business Name</font></b></p></td>
                  <td width="30%">
                    <p align="center"><select size="1" name="lstBname" style="width: 198; height: 23" OnChange="ChangeOrg()">
					<option value=0 <% if OrgID=0 then response.write("selected") %>>New Organization</option>
<% for i=0 to tIndex-1 %>
					<option value="<%= OrgAcct(i) %>" <% if OrgID=OrgAcct(i) then response.write("selected") %>><%= DBAname(i) %></option>
<% next %>
					</select></td>
                  <td width="28%">&nbsp;</td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="30%" bgcolor="#f8d5b6"><b><font size="2">1.
                    Business Information</font></b></td>
                  <td width="30%" bgcolor="#f8d5b6">&nbsp;</td>
                  <td width="28%" bgcolor="#f8d5b6">&nbsp;</td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2">Business
                    Name (DBA)</font></b></td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2"><input name="txtDBA" size="28" Value="<%= vDBA %>"></font></b></td>
                  <td width="28%" bgcolor="#fef7f1">&nbsp;</td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2">Business
                    Legal Name</font></b></td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2"><input name="txtBname" size="28" Value="<%= vBname %>"></font></b></td>
                  <td width="28%" bgcolor="#fef7f1">&nbsp;</td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2">Business
                    Taxpayer ID</font></b></td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2"><input name="txtTaxID" size="28" Value="<%= vTaxID %>"></font></b></td>
                  <td width="28%" bgcolor="#fef7f1">&nbsp;</td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2">Business
                    Address</font></b></td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2"><input name="txtBaddress" size="28" Value="<%= vBaddress %>"></font></b></td>
                  <td width="28%" bgcolor="#fef7f1">&nbsp;</td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2">Business
                    City</font></b></td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2"><input name="txtBcity" size="28" Value="<%= vBcity %>"></font></b></td>
                  <td width="28%" bgcolor="#fef7f1">&nbsp;</td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2">Business
                    State</font></b></td>
                  <td width="30%" bgcolor="#fef7f1"><select size="1" name="lstBstate" style="WIDTH: 105px">
					<option>Select One</option>
<% for i=0 to 50 %>
                    <option <% if vBstate=USState(i) then response.write("selected") %>><%= USState(i) %></option>
<% next %>
					</select></td>
                  <td width="28%" bgcolor="#fef7f1">&nbsp;</td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2">Business
                    Zip</font></b></td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2"><input name="txtBzip" size="28" Value="<%= vBzip %>"></font></b></td>
                  <td width="28%" bgcolor="#fef7f1">&nbsp;</td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2">Business
                    Country</font></b></td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2"><select name="lstBcountry" style="WIDTH: 105px">
<% for i=0 to cyIndex-1 %>
					<option value="<%= aCountry(i) & "-" & aCountryCode(i) %>" <% if vBCountryCode=aCountryCode(i) then response.write("selected") %>><%= aCountry(i) %></option>
<% next %>
					</select>
				  </font></b></td>
                  <td width="28%" bgcolor="#fef7f1">&nbsp;</td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2">Business
                    URL</font></b></td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2"><input name="txtBurl" size="28" Value="<%= vBurl %>"></font></b></td>
                  <td width="28%" bgcolor="#fef7f1">&nbsp;</td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2">Business
                    Phone Number</font></b></td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2"><input name="txtBphone" size="28" Value="<%= vBphone %>"></font></b></td>
                  <td width="28%" bgcolor="#fef7f1">&nbsp;</td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2">Business
                    Fax Number</font></b></td>
                  <td width="30%" bgcolor="#fef7f1"><b><font size="2"><input name="txtBfax" size="28" Value="<%= vBfax %>"></font></b></td>
                  <td width="28%" bgcolor="#fef7f1">&nbsp;</td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="84%" colspan="3">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                      <tr>
                        <td width="25%" bgcolor="#f8d5b6"><b><font size="2">2.
                          Contact Information</font></b></td>
                        <td width="25%" bgcolor="#f8d5b6">&nbsp;</td>
                        <td width="25%" bgcolor="#f8d5b6">&nbsp;</td>
                        <td width="25%" bgcolor="#f8d5b6">&nbsp;</td>
                      </tr>
                      <tr>
                        <td width="25%" bgcolor="#fef7f1"><b><font size="2">Contact
                          First Name</font></b></td>
                        <td width="25%" bgcolor="#fef7f1"><b><font size="2"><input name="txtCFname" Value="<%= vCFname %>"
                       ></font></b></td>
                        <td width="25%" bgcolor="#fef7f1"><b><font size="2">Contact
                          Last Name</font></b></td>
                        <td width="25%" bgcolor="#fef7f1"><b><font size="2"><input name="txtCLname" Value="<%= vCLname %>"
                       ></font></b></td>
                      </tr>
                      <tr>
                        <td width="25%" bgcolor="#fef7f1"><b><font size="2">Contact
                          Phone Number</font></b></td>
                        <td width="25%" bgcolor="#fef7f1"><b><font size="2"><input name="txtCPhone" Value="<%= vCphone %>"
                       ></font></b></td>
                        <td width="25%" bgcolor="#fef7f1"><b><font size="2">Contact
                          Mailing address</font></b></td>
                        <td width="25%" bgcolor="#fef7f1"><b><font size="2"><input name="txtCaddress" Value="<%= vCaddress %>"
                       ></font></b></td>
                      </tr>
                      <tr>
                        <td width="25%" bgcolor="#fef7f1"><b><font size="2">Contact
                          Mailing&nbsp; City</font></b></td>
                        <td width="25%" bgcolor="#fef7f1"><b><font size="2"><input name="txtCcity" Value="<%= vCcity %>"
                       ></font></b></td>
                        <td width="25%" bgcolor="#fef7f1"><b><font size="2">Contact
                          Mailing State</font></b></td>
                        <td width="25%" bgcolor="#fef7f1"><select size="1" name="lstCstate" style="WIDTH: 100px">
					<option>Select One</option>
<% for i=0 to 50 %>
                    <option <% if vCstate=USState(i) then response.write("selected") %>><%= USState(i) %></option>
<% next %>
						</select></td>
                      </tr>
                      <tr>
                        <td width="25%" bgcolor="#fef7f1"><b><font size="2">Contact
                          Mailing Zip</font></b></td>
                        <td width="25%" bgcolor="#fef7f1"><b><font size="2"><input name="txtCzip" Value="<%= vCzip %>"
                       ></font></b></td>
                        <td width="25%" bgcolor="#fef7f1"><b><font size="2">Contact
                          Mailing Country</font></b></td>
                        <td width="25%" bgcolor="#fef7f1"><b><font size="2"><select name="lstCcountry" style="WIDTH: 105px">
<% for i=0 to cyIndex-1 %>
					<option value="<%= aCountry(i) %>" <% if vCCountry=aCountryCode(i) or vCCountry=aCountry(i) then response.write("selected") %>><%= aCountry(i) %></option>
<% next %>
					</select>
				  </font></b></font></b></td>
                      </tr>
                      <tr>
                        <td width="25%" bgcolor="#fef7f1"><b><font size="2">Contact
                          Email Address</font></b></td>
                        <td width="50%" colspan="2" bgcolor="#fef7f1"><b><font size="2"><input name="txtCemail" size="41" Value="<%= vCemail %>"></font></b></td>
                        <td width="25%" bgcolor="#fef7f1">&nbsp;</td>
                      </tr>
                    </table>
                  </td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="86%" colspan="3" bgcolor="#f8d5b6"><font size="2"><b>3.
                    Business Type</b></font></td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="86%" colspan="3">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                      <tr>
                        <td width="13%" bgcolor="#fef7f1"><font size="2"><b>Is
                          Shipper&nbsp;&nbsp; </b></font></td>
                        <td width="12%" bgcolor="#fef7f1"><font size="2"><b><input type="checkbox" name="cShipper" value="Y" <% if IsShipper="Y" then response.write("checked") %>></b></font></td>
                        <td width="25%" bgcolor="#fef7f1" colspan="2">&nbsp;</td>
                        <td width="13%" bgcolor="#fef7f1"><font size="2"><b>Is
                          Consignee</b></font></td>
                        <td width="12%" bgcolor="#fef7f1"><font size="2"><b><input type="checkbox" name="cConsignee" value="Y" <% if IsConsignee="Y" then response.write("checked") %>></b></font></td>
                        <td width="25%" bgcolor="#fef7f1">&nbsp;</td>
                      </tr>
                      <tr>
                        <td width="13%" bgcolor="#fef7f1"></td>
                        <td width="12%" bgcolor="#fef7f1"></td>
                        <td width="25%" bgcolor="#fef7f1" colspan="2"></td>
                        <td width="13%" bgcolor="#fef7f1"><font size="2"><b>Broker Info</b></font></td>
                        <td width="12%" bgcolor="#fef7f1"><TEXTAREA name=txtBrokerInfo rows=3 cols=25><%= vBrokerInfo %></TEXTAREA></td>
                        <td width="25%" bgcolor="#fef7f1"></td>
                      </tr>
                      <tr>
                        <td width="13%" bgcolor="#fef7f1"><font size="2"><b>Is
                          Agent&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; </b></font></td>
                        <td width="4%" bgcolor="#fef7f1"><font size="2"><b><input type="checkbox" name="cAgent" value="Y" <% if IsAgent="Y" then response.write("checked") %>></b></font></td>
                        <td width="25%" bgcolor="#fef7f1" style="position: relative; left: 0; top: 0; width: 0; height: 0"><font size="1"><b>EDT</b></font><input type="checkbox" name="cEDT" Value="Y" <% if vEDT="Y" then response.write("checked") %>></td>
                        <td width="12%" bgcolor="#fef7f1"><font size="1"><b>ELT ACCT</b></font><input type="text" name="txtAgentELTAcct" value="<%= vAgentELTAcct %>" size="8"></td>
                        <td width="13%" bgcolor="#fef7f1"><font size="2"><b>Is
                          Vendor</b></font></td>
                        <td width="12%" bgcolor="#fef7f1"><font size="2"><b><input type="checkbox" name="cVendor" value="Y" <% if IsVendor="Y" then response.write("checked") %>></b></font></td>
                        <td width="13%" bgcolor="#fef7f1">&nbsp;</td>
                      </tr>
                      <tr>
                        <td width="13%" bgcolor="#fef7f1"></td>
                        <td width="4%" bgcolor="#fef7f1"></td>
                        <td width="25%" bgcolor="#fef7f1" style="position: relative; left: 0; top: 0; width: 0; height: 0"><font size="1"><b>IATA Code</b></font><input type="text" name="txtIATACode" value="<%= vIATACode %>" size="5"></td>
                        <td width="12%" bgcolor="#fef7f1"></td>
                        <td width="13%" bgcolor="#fef7f1"></td>
                        <td width="12%" bgcolor="#fef7f1"></td>
                        <td width="13%" bgcolor="#fef7f1">&nbsp;</td>
                      </tr>
                      <tr>
                        <td width="13%" bgcolor="#fef7f1"><font size="2"><b>Is
                          Carrier</b></font></td>
                        <td width="12%" bgcolor="#fef7f1"><font size="2"><b><input type="checkbox" name="cCarrier" value="Y" <% if IsCarrier="Y" then response.write("checked") %>></b></font></td>
                        <td width="13%" bgcolor="#fef7f1" style="position: relative; left: 0; top: 0; width: 0; height: 0"><font size="2"><b>Carrier
                          Code(Numeric)&nbsp;</b></font></td>
                        <td width="12%" bgcolor="#fef7f1"><input type="text" name="txtCarrierCode" value="<%= vCarrierCode %>" size="9"></td>
                        <td width="13%" bgcolor="#fef7f1"><b><font size="2">Carrier
                          Code(Alphabetic)</font></b></td>
                        <td width="12%" bgcolor="#fef7f1"><input type="text" name="txtCarrierID" value="<%= vCarrierID %>" size="9"></td>
                        <td width="25%" bgcolor="#fef7f1"><b><font size="2">Carrier Type</font></b>&nbsp;&nbsp;<select Name="lstCarrierType">
						<option Value="A">Air</option>
						<option Value="O" <% if vCarrierType="O" then response.write("selected") %>>Ocean</option>
						</select></td>
                      </tr>
                      <tr>
                        <td width="13%" bgcolor="#fef7f1"><font size="2"><b>Is Colodee</b></font></td>
                        <td width="12%" bgcolor="#fef7f1"><font size="2"><b><input type="checkbox" name="cColodee" value="Y" <% if IsColodee="Y" then response.write("checked") %>></b></font></td>
                        <td width="13%" bgcolor="#fef7f1" style="position: relative; left: 0; top: 0; width: 0; height: 0"><font size="2"><b>Colodee List&nbsp;</b></font></td>
                        <td width="12%" bgcolor="#fef7f1"><select name="lstColodee" style="HEIGHT: 22px; WIDTH: 150px;">
<% for i=0 to coIndex-1 %>
					<option Value="<%= aColodeeAcct(i) %>" <% if cLng(vColodeeELTAcct)=aColodeeAcct(i) then response.write("selected") %>><%= aColodeeName(i) %></option>
<% next %>
				  </select></td>
                        <td width="13%" bgcolor="#fef7f1"><b><font size="2">&nbsp;</font></b></td>
                        <td width="12%" bgcolor="#fef7f1">&nbsp;</td>
                        <td width="25%" bgcolor="#fef7f1">&nbsp;</td>
                      </tr>
                    </table>
                  </td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="86%" colspan="3" bgcolor="#f8d5b6"><font size="2"><b>4. Invoice Term</b></font></td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="86%" colspan="3">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                      <tr>
                        <td width="12%" bgcolor="#fef7f1"><font size="2"><b>Term</b></font> <input type="text" name="txtInvoiceTerm" value="<%= vInvoiceTerm %>" size="9"></td>
                        <td width="25%" bgcolor="#fef7f1">&nbsp;</td>
                      </tr>
                    </table>
                  </td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="86%" colspan="3" bgcolor="#f8d5b6"><font size="2"><b>5. Account Status</b></font></td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="86%" colspan="3">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                      <tr>
                        <td width="12%" bgcolor="#fef7f1"><input type="checkbox" name="cAccountStatus" Value="A" <% if vAccountStatus="A" then response.write("checked") %>><font size="2"><b>Active</b></font></td>
                        <td width="25%" bgcolor="#fef7f1">&nbsp;</td>
                      </tr>
                    </table>
                  </td>
                  <td width="6%">&nbsp;</td>
                </tr>
                <tr>
                  <td width="6%">&nbsp;</td>
                  <td width="86%" colspan="3">
                    <table border="0" cellpadding="0" cellspacing="0" width="100%">
                      <tr>
                        <td width="100%" colspan="2" bgcolor="#f8d5b6">&nbsp;</td>
                      </tr>
                      <tr>
                        <td width="25%" bgcolor="#fef7f1"><font size="2"><b>Comment</b></font></td>
                        <td width="75%" bgcolor="#fef7f1"><font size="2"><b>&nbsp;&nbsp; <TEXTAREA name=txtComment rows=3 cols=52><%= vComment %></TEXTAREA></b></font></td>
                      </tr>
                    </table>
                  </td>
                  <td width="6%">&nbsp;</td>
                </tr>
              </table>
            </td>
          </tr>
        </table>
      </form>
      <p align="center"><input type="button" value="Add Organization" name="bSave1" OnClick="AddClick()" style="COLOR: #3d1f1f; BACKGROUND-COLOR: #ffffff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
      <input type="button" value="Update Organization" name="bSave2" OnClick="UpdateClick()" style="COLOR: #3d1f1f; BACKGROUND-COLOR: #ffffff">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	  <input type="button" value="Delete Organization" name="bDelete" OnClick="DeleteClick()" style="COLOR: #3d1f1f; BACKGROUND-COLOR: #ffffff"></p></td>
  </tr>
  <tr>
    <td width="100%">
      <p align="center">&nbsp;</p></td>
  </tr>
</table>

</body>

<script language="VBScript">
<!--
AskOperationDelete="<%= AskOperationDelete %>"
OrgID="<%= OrgID %>"
if AskOperationDelete="yes" then
	ok=MsgBox ("There is operation data for this organization. Do you still want to delete?" & chr(13) & "Yes?",36,"Message")
	if ok=6 then	
		document.form1.action="edit_org.asp?DeleteOrg=yes&OperationDeleteOK=yes&OrgID=" & OrgID
		document.form1.method="POST"
		form1.submit()
	end if
end if
AddOrg="<%= AddOrg %>"
UpdateOrg="<%= UpdateOrg %>"
DeleteOrg="<%= DeleteOrg %>"
if AddOrg="yes" or UpdateOrg="yes" or DeleteOrg="yes" then
	Set fso = CreateObject("Scripting.FileSystemObject")
	tIndex=<%= tIndex %>
	if tIndex>0 then
		Set OutFile=fso.CreateTextFile("<%=temp_path%>" & "\EltData\AllOrgInfo.elt", True)
		for i=1 to tIndex
			AllOrgInfo=document.all("AllOrgInfo").item(i).value
			OutFile.WriteLine(AllOrgInfo)
		next
		OutFile.Close
		Set OutFile=Nothing
	end if
	Set fso=Nothing
end if
Sub AddClick()
NoItem=Cint(document.form1.hNoItem.Value)
OrgID=clng(document.form1.lstBname.Value)
for i=1 to NoItem-1
	if OrgID=clng(document.form1.lstBname.item(i).Value) then
		MsgBox "The Organization is already created!"
		exit Sub
	end if
next
if not document.form1.txtDBA.Value="" And not AddOrg=False then
	if document.form1.cColodee.checked=true And document.form1.lstColodee.selectedindex=0 then
		MsgBox "Please select colodee!"
		exit sub
	elseif Not document.form1.txtAgentELTAcct.Value="" then
		AgentELTAcct=document.form1.txtAgentELTAcct.Value
		if not len(AgentELTAcct)=8 or Not IsNumeric(AgentELTAcct) then
			MsgBox "Please enter a 8 digits numeric number!"
			exit sub
		end if
	end if
end if
	document.form1.action="edit_org.asp?AddOrg=yes"
	'document.form1.ACTION="mailto:skang@merchante-solutions.com?subject=Feedback&body=The InetSDK Site Is Superlative"
	'form.formBody.Value="12345678"
	document.form1.method="post"
	form1.submit()
End Sub
Sub DeleteClick()
sIndex=cint(form1.lstBname.selectedindex)
OrgID=clng(document.form1.lstBname.Value)
OrgName=document.form1.lstBname.item(sIndex).Text
if sIndex>0 then
	ok=MsgBox ("Are you sure you want to delete " & OrgName & "?" & chr(13) & "",36,"Message")
	if ok=6 then	
		document.form1.action="edit_org.asp?DeleteOrg=yes&OrgID=" & OrgID
		document.form1.method="post"
		form1.submit()
	end if
end if
End Sub

Sub UpdateClick()
NoItem=Cint(document.form1.hNoItem.Value)
sIndex=cint(form1.lstBname.selectedindex)
OrgID=clng(document.form1.lstBname.Value)
UpdateOrg=True
if sIndex=0 then
	UpdateOrg=False
end if
if not UpdateOrg=False then
	if document.form1.cColodee.checked=true And document.form1.lstColodee.selectedindex=0 then
		MsgBox "Please select colodee!"
		UpdateOrg=False
	elseif Not document.form1.txtAgentELTAcct.Value="" then
		AgentELTAcct=document.form1.txtAgentELTAcct.Value
		if Not AgentELTAcct=0 then
			if not len(AgentELTAcct)=8 or Not IsNumeric(AgentELTAcct) then
				MsgBox "Please enter a 8 digits numeric number!"
				UpdateOrg=False
			end if
		end if
	end if
end if
if Not UpdateOrg=False then
	document.form1.action="edit_org.asp?UpdateOrg=yes&OrgID=" & OrgID
	document.form1.method="POST"
	form1.submit()
end if
End Sub
Sub ChangeOrg()
sIndex=form1.lstBname.selectedindex
OrgID=cint(document.form1.lstBname.item(sIndex).Value)
if sIndex>=0 then
	document.form1.action="edit_org.asp?EditOrg=yes&OrgID=" & OrgID
	document.form1.method="POST"
	form1.submit()
end if
End Sub
Sub MenuMouseOver()
  document.form1.lstBname.style.visibility="hidden"
End Sub
Sub MenuMouseOut()
  document.form1.lstBname.style.visibility="visible"
End Sub
-->
</script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
