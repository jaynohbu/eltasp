<%@ LANGUAGE = VBScript %>
<html>
<head>
<title>Flight Number</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<!--  #INCLUDE FILE="../include/connection.asp" -->
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
<%
Save=Request.QueryString("Save")
Set rs = Server.CreateObject("ADODB.Recordset")
if Save="Yes" or Go="Yes" then
	vFlightNo=Request("txtFlightNo")
	vPOD=Request("lstPOD")
	vPOA=Request("lstPOA")
	SQL= "select * from flight_no where elt_account_number = " & elt_account_number & " and flight_no='" & vFlightNo & "'"
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	if rs.EOF then
		rs.AddNew
		rs("elt_account_number")=elt_account_number
		rs("flight_no")=vFlightNo
	end if
	rs("pod")=vPOD
	rs("poa")=vPOA
	rs.Update
	rs.close
end if
'get airline info
Dim CarrierName(128),CarrierCode(128),SCAC(128)
SQL= "select dba_name,carrier_code,carrier_id from organization where elt_account_number = " & elt_account_number & " and is_carrier='Y' And carrier_type='A' order by dba_name"
rs.Open SQL, eltConn, , , adCmdText
aIndex=1
CarrierName(0)="Select One"
CarrierCode(0)=0
Do While Not rs.EOF
	CarrierName(aIndex)=rs("dba_name")
	SCAC(aIndex)=rs("carrier_id")
	aIndex=aIndex+1
	rs.MoveNext
Loop
rs.Close

'GET PORT INFO
Dim PortCode(200),PortID(200),PortDesc(200),PortState(200),PortCountry(200),PortCountryCode(200)
SQL= "select * from port where elt_account_number = " & elt_account_number & " order by port_desc"
rs.Open SQL, eltConn, , , adCmdText
pIndex=0
Do While Not rs.EOF
	PortCode(pIndex)=rs("port_code")
	PortID(pIndex)=rs("port_id")
	PortDesc(pIndex)=rs("port_desc")
	PortState(pIndex)=rs("port_state")
	PortCountry(pIndex)=rs("port_country")
	PortCountryCode(pIndex)=rs("port_country_code")
	pIndex=pIndex+1
	rs.MoveNext
Loop
rs.Close
%>
<body link="336699" vlink="336699" leftmargin="0" topmargin="0">
<table width="100%" height="12" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center" valign="top"><img src="../images/spacer.gif" width="560" height="6"><img src=<% 
	
	if Not isPopWin then  
	response.write("'../images/pointer_md.gif'") 
	end if%> width="11" height="7"><img src="../images/spacer.gif" width="27" height="6"></td>
  </tr>
</table>
<br>
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr>
    <td height="32" align="left" valign="middle" class="pageheader">Flight Number</td>
  </tr>
</table>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="73beb6" bgcolor="#73beb6" class="border1px">
  <tr> 
    <td>
	<form name="form1" method="post">
	    <table width="100%" border="0" cellpadding="2" cellspacing="0">
          <tr bgcolor="ccebed"> 
            <td width="2" height="8" align="left" valign="top" bgcolor="ccebed"></td>
          </tr>
          <tr bgcolor="73beb6"> 
            <td height="1" align="left" valign="top"></td>
          </tr>
          <tr align="left" bgcolor="ecf7f8"> 
            <td height="22" align="center" valign="middle" bgcolor="ecf7f8" class="bodycopy"><br>
			   <table width="45%" border="0" cellpadding="2" cellspacing="0" bordercolor="73beb6" bgcolor="edd3cf" class="border1px">
                <tr align="left" valign="middle" bgcolor="#FFFFFF"> 
                  <td width="13" align="left" valign="middle" class="bodycopy">&nbsp;</td>
                  <td width="100" align="left" valign="middle" bgcolor="#FFFFFF">Carrier 
                  </td>
                  <td width="309" align="left" valign="middle"> 
                    <select name="lstCarrier" size="1" class="shorttextfield" style="WIDTH: 160px" tabindex=3 OnChange="CarrierChange()">
                      <% for i=0 to aIndex-1 %>
                      <option value="<%= SCAC(i) %>" <% if Mid(vFlightNo,1,2)=SCAC(i) then response.write("selected") %>><%= CarrierName(i) %></option>
                      <% next %>
                    </select></td>
                </tr>
                <tr bgcolor="f3f3f3"> 
                  <td height="18" align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">Flight No</td>
                  <td align="left" valign="middle"><input name="txtFlightNo" class="shorttextfield" Value="<%= vFlightNo %>" size="23"></td>
                </tr>
                <tr bgcolor="#FFFFFF"> 
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">Departure Port</td>
                  <td align="left" valign="middle"><select name="lstPOD" size="1" class="smallselect" style="WIDTH: 160px" tabindex=6>
                      <option Value="">Select One</option>
                      <% for i= 0 to pIndex-1 %>
                      <Option Value="<%= PortCode(i) %>" <% if vPOD=PortCode(i) Then response.write("selected") %>><%= PortCode(i) & "-" & PortDesc(i) %></Option>
                      <% next %>
                    </select></td>
                </tr>
                <tr bgcolor="f3f3f3"> 
                  <td align="left" valign="middle">&nbsp;</td>
                  <td align="left" valign="middle">Destination Port</td>
                  <td align="left" valign="middle"><select name="lstPOA" size="1" class="smallselect" style="WIDTH: 160px" tabindex="7"
           >
                      <Option Value="">Select One</Option>
                      <% for i= 0 to pIndex-1 %>
                      <Option Value="<%= PortCode(i) %>" <% if vPOA=PortCode(i) Then response.write("selected") %>><%= PortCode(i) & "-" & PortDesc(i) %></Option>
                      <% next %>
                    </select></td>
                </tr>
                <tr bgcolor="73beb6"> 
                  <td height="1" colspan="3" align="left" valign="middle"></td>
                </tr>
                <tr align="center" bgcolor="ecf7f8"> 
                  <td height="20" colspan="3" valign="middle"><img src="../images/button_save.gif" width="55" height="18" name="bSave" OnClick="bSaveClick()" style="cursor:hand"></td>
                </tr>
              </table>
              <br>
            </td>
          </tr>
          <tr bgcolor="73beb6"> 
            <td height="1" align="left" valign="top"></td>
          </tr>
          <tr align="center" bgcolor="ccebed"> 
            <td height="22" valign="middle" class="bodycopy">&nbsp;</td>
          </tr>
        </table>
      </form></td>
        </tr>
</table>
<br>
</body>
<SCRIPT LANGUAGE="vbscript">
<!---
Sub bsaveclick()
	document.form1.action="create_flight.asp?save=Yes" & "&WindowName=" & window.name
	Document.form1.target = "_self"
	document.form1.method="POST"
	form1.submit()
End Sub
Sub CarrierChange()
sindex=document.form1.lstCarrier.selectedindex
if sindex>0 then
	CarrierInfo=document.form1.lstCarrier.item(sindex).Value
	document.form1.txtFlightNo.Value=CarrierInfo
end if
End Sub
Sub MenuMouseOver()
End Sub
Sub MenuMouseOut()
End Sub
--->
</SCRIPT>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
