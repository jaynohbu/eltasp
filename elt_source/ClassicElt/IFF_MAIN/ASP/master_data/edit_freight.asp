<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>Edit Freight Location</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <!--  #INCLUDE FILE="../include/connection.asp" -->
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #INCLUDE FILE="../include/countrystates.asp" -->
<%
Dim rs, SQL,add,delete,update,dAccount,TranNo,tNo,tIndex,i,j,rNo
Dim aLocation(200),aFirmCode(200),aPhone(200),aFax(200),aAddress(200),aCity(200),aState(200),aCountry(200)
Dim vLocation,vFirmCode,vPhone,vFax,vAddress,vCity,vState,vCountry,dFirmCode
Set rs = Server.CreateObject("ADODB.Recordset")
add=Request("add")
delete=Request("delete")
update=Request("update")
if delete="yes" then
	dFirmCode=Request.QueryString("dFirmCode")
	SQL= "delete freight_location where elt_account_number = " & elt_account_number & " and firm_code=N'" & dFirmCode & "'"
	eltConn.Execute SQL
end if
if update="yes" then
	rNo=Request.QueryString("rNo")
	vLocation=Request("txtLocation" & rNo)
	vFirmCode=Request("txtFirmCode" & rNo)
	vPhone=Request("txtPhoneCode" & rNo)
	vFax=Request("txtFax" & rNo)
	vAddress=Request("txtAddress" & rNo)
	vCity=Request("txtCity" & rNo)
	vState=Request("lstState" & rNo)
	vCountry=Request("lstCountry" & rNo)
	SQL= "select * from freight_location where elt_account_number = " & elt_account_number & " and firm_code=N'" & vFirmCode & "'"
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	if Not rs.EOF Then 
		rs("location") = vLocation
		rs("phone") = vPhone
		rs("fax") = vFax
		rs("address") = vAddress
		rs("city") = vCity
		rs("state") = vState
		rs("country") = vCountry
		rs.Update
	end if
	rs.Close
end if
TranNo=Session("TranNo")
if TranNo="" then
Session("TranNo")=0
TranNo=0
end if
tNo=CInt(Request.QueryString("tNo"))
if add="yes" And tNo=TranNo then
  	Session("TranNo")=Clng(Session("TranNo"))+1
	TranNo=Clng(Session("TranNo"))
	vLocation=Request("txtLocation")
	vFirmCode=Request("txtFirmCode")
	vPhone=Request("txtPhoneCode")
	vFax=Request("txtFax")
	vAddress=Request("txtAddress")
	vCity=Request("txtCity")
	vState=Request("lstState")
	vCountry=Request("lstCountry")
	
	SQL= "select * from freight_location where elt_account_number = " & elt_account_number & " and firm_code=N'" & vFirmCode & "'"
	rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
	'rs.Open "freight_location", eltConn, adOpenDynamic, adLockPessimistic, adCmdTable
	if rs.eof then
		rs.AddNew
		rs("elt_account_number") = elt_account_number
		rs("location") = vLocation
		rs("firm_code") = vFirmCode
		rs("phone") = vPhone
		rs("fax") = vFax
		rs("address") = vAddress
		rs("city") = vCity
		rs("state") = vState
		rs("country") = vCountry
		rs.Update
	end if
	rs.Close	
end if

SQL= "select * from freight_location where elt_account_number = " & elt_account_number & " order by location"
rs.CursorLocation = adUseClient
rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
Set rs.activeConnection = Nothing
tIndex=0
Do While Not rs.EOF
	aLocation(tIndex)=rs("location")
	aFirmCode(tIndex)=rs("firm_code")
	aPhone(tIndex)=rs("phone")
	aFax(tIndex)=rs("fax")
	aAddress(tIndex)=rs("address")
	aCity(tIndex)=rs("city")
	aState(tIndex)=rs("state")
	aCountry(tIndex)=rs("country")
	tIndex=tIndex+1
	rs.MoveNext
Loop
rs.Close
Set rs=Nothing

%>
<!--  #include file="../include/recent_file.asp" -->
<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
    <!-- tooltip placeholder -->
    <div id="tooltipcontent">
    </div>
    <!-- placeholder ends -->
    <table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
        <tr>
            <td height="32" align="left" valign="middle" class="pageheader">
                Freight Location</td>
        </tr>
    </table>
    <form name="form1" method="post">
        <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#73beb6"
            bgcolor="#73beb6" class="border1px">
            <tr>
                <td>
                    <!-- start of scroll bar -->
                    <input type="hidden" name="scrollPositionX">
                    <input type="hidden" name="scrollPositionY">
                    <!-- end of scroll bar -->
                    <input type="hidden" id="hNoItem" value="<%= tIndex %>">
                    <table width="100%" border="0" cellpadding="2" cellspacing="0">
                        <tr>
                            <td height="8" colspan="11" align="left" valign="top" bgcolor="ccebed" class="bodyheader">
                            </td>
                        </tr>
                        <tr>
                            <td height="1" colspan="11" align="left" valign="top" bgcolor="73beb6" class="bodyheader">
                            </td>
                        </tr>
                        <tr align="left" valign="middle">
                            <td width="2" height="22" bgcolor="ecf7f8">
                                &nbsp;</td>
                            <td bgcolor="ecf7f8" class="bodyheader">
                                Location</td>
                            <td bgcolor="ecf7f8" class="bodyheader">
                                Firms Code</td>
                            <td bgcolor="ecf7f8" class="bodyheader">
                                Phone</td>
                            <td bgcolor="ecf7f8" class="bodyheader">
                                Fax</td>
                            <td bgcolor="ecf7f8" class="bodyheader">
                                Address</td>
                            <td bgcolor="ecf7f8" class="bodyheader">
                                City</td>
                            <td bgcolor="ecf7f8" class="bodyheader">
                                State</td>
                            <td bgcolor="ecf7f8" class="bodyheader">
                                Country
                                <% if mode_begin then %>
                                <div style="width: 21px; display: inline; vertical-align: middle" onmouseover="showtip('This list of countries is set up in the Site Admin > Company Information > Country Master portion of the system.');"
                                    onmouseout="hidetip()">
                                    <img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
                                <% end if %>
                            </td>
                            <td bgcolor="ecf7f8" class="bodyheader">
                                &nbsp;</td>
                            <td bgcolor="ecf7f8" class="bodyheader">
                                &nbsp;</td>
                        </tr>
                        <tr align="left" valign="middle">
                            <td height="2" colspan="11" bgcolor="73beb6" class="bodyheader">
                            </td>
                        </tr>
						<% for i=0 to tIndex-1 %>
                        <%next%>
                        <tr>
                            <td bgcolor="f3f3f3">
                            </td>
                            <td bgcolor="f3f3f3">
                                <input name="txtLocation" type="text" class="shorttextfield" maxlength="128" value="<%= aLocation(i) %>"
                                    size="20"></td>
                            <td bgcolor="f3f3f3">
                                <input name="txtFirmCode" type="text" class="shorttextfield" maxlength="8" value="<%= aFirmCode(i) %>"
                                    size="7"></td>
                            <td bgcolor="f3f3f3">
                                <input name="txtPhoneCode" type="text" class="m_shorttextfield" preset="phone" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                    value="<%= aPhone(i) %>" size="14"></td>
                            <td bgcolor="f3f3f3">
                                <input name="txtFax" type="text" class="m_shorttextfield" preset="phone" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                    value="<%= aFax(i) %>" size="14"></td>
                            <td bgcolor="f3f3f3">
                                <input name="txtAddress" type="text" class="shorttextfield" maxlength="128" value="<%= aAddress(i) %>"
                                    size="34"></td>
                            <td bgcolor="f3f3f3">
                                <input name="txtCity" type="text" class="shorttextfield" maxlength="64" value="<%= aCity(i) %>"
                                    size="21"></td>
                            <td bgcolor="f3f3f3">
                                <select name="lstState" size="1" class="smallselect" id="select3">
                                    <option value="0"></option>
                                    <% for j=0 to 50 %>
                                    <option>
                                        <%= USState(j) %>
                                    </option>
                                    <% next %>
                                </select>
                            </td>
                            <td bgcolor="f3f3f3">
                                <select name="lstCountry" size="1" class="smallselect" id="select4" style="width: 100px">
                                    <option value="0">Select One</option>
                                    <% for j=0 to countryIndex %>
                                    <option>
                                        <%= AllCountryDesc(j) %>
                                    </option>
                                    <% next %>
                                </select>
                            </td>
                            <td bgcolor="f3f3f3">
                                <img src="../images/button_add_bold.gif" width="37" height="17" onclick="AddPort(<%= TranNo %>)"
                                    style="cursor: hand"></td>
                            <td bgcolor="f3f3f3">
                            </td>
                        </tr>
                        <tr align="left" valign="middle">
                            <td height="1" colspan="11" bgcolor="73beb6" class="bodyheader">
                            </td>
                        </tr>
                        <tr>
                            <td bgcolor="#FFFFFF">
                            </td>
                            <td colspan="10" bgcolor="#FFFFFF">
                                &nbsp;</td>
                        </tr>
                        <input type="hidden" id="FirmCode">
                        <input type="hidden" id="Country">
                        <input type="hidden" id="State">
                        <% for i=0 to tIndex-1 %>
                        <tr align="left" valign="middle" class="bodycopy">
                            <td bgcolor="#FFFFFF">
                                <td bgcolor="#FFFFFF">
                                    <input name="txtLocation<%= i %>" type="text" maxlength="128" class="shorttextfield"
                                        size="20" value="<%= aLocation(i) %>"></td>
                                <td bgcolor="#FFFFFF">
                                    <input name="txtFirmCode<%= i %>" type="text" class="d_shorttextfield" maxlength="8"
                                        id="FirmCode" size="7" value="<%= aFirmCode(i) %>" readonly="true"></td>
                                <td bgcolor="#FFFFFF">
                                    <input name="txtPhoneCode<%= i %>" type="text" class="m_shorttextfield" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                        preset="phone" size="14" value="<%= aPhone(i) %>"></td>
                                <td bgcolor="#FFFFFF">
                                    <input name="txtFax<%= i %>" type="text" class="m_shorttextfield" style="behavior: url(../include/igNumDotChkLeft.htc)"
                                        preset="phone" size="14" value="<%= aFax(i) %>"></td>
                                <td bgcolor="#FFFFFF">
                                    <input name="txtAddress<%= i %>" type="text" maxlength="128" class="shorttextfield"
                                        size="34" value="<%= aAddress(i) %>"></td>
                                <td bgcolor="#FFFFFF">
                                    <input name="txtCity<%= i %>" type="text" maxlength="64" class="shorttextfield" size="21"
                                        value="<%= aCity(i) %>"></td>
                                <td bgcolor="#FFFFFF">
                                    <select name="lstState<%= i %>" size="1" class="smallselect" id="State">
                                        <option value="0"></option>
                                        <% for j=0 to 50 %>
                                        <option <% if USState(j)=aState(i) then response.write("selected") %>>
                                            <%= USState(j) %>
                                        </option>
                                        <% next %>
                                    </select>
                                </td>
                                <td bgcolor="#FFFFFF">
                                    <select name="lstCountry<%= i %>" size="1" class="smallselect" id="Country" style="width: 100px">
                                        <option value="0">Select One</option>
                                        <% for j=0 to UBound(AllCountryDesc)-1 %>
                                        <option value="<%= AllCountryDesc(j) %>" <% if aCountry(i)=AllCountryDesc(j) then response.write("selected") %>>
                                            <%= AllCountryDesc(j) %>
                                        </option>
                                        <% next %>
                                    </select>
                                </td>
                                <td bgcolor="#FFFFFF">
                                    <img src="../images/button_delete.gif" width="50" height="17" onclick="DeletePort('<%= aFirmCode(i) %>')"
                                        style="cursor: hand"></td>
                                <td bgcolor="#FFFFFF" class="bodyheader">
                                    <img src="../images/button_update.gif" width="52" height="18" onclick="UpdatePort(<%= i %>)"
                                        style="cursor: hand"></td>
                        </tr>
                        <% Response.Flush() %>
                        <% next %>
                        <tr>
                            <td colspan="11" style="background-color: #ffffff; height: 10px">
                            </td>
                        </tr>
                        <tr>
                            <td height="1" colspan="11" align="left" valign="top" bgcolor="73beb6" class="bodyheader">
                            </td>
                        </tr>
                        <tr>
                            <td height="20" colspan="11" align="right" valign="middle" bgcolor="ccebed" class="bodycopy">
                                &nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
    </form>
</body>

<script type="text/vbscript">
<!---
Sub AddPort(TranNo)
Dim AddOK
AddOK=false
FirmCode=Document.form1.txtFirmCode.Value
tIndex=cInt(document.form1.hNoItem.Value)

if Not FirmCode="" then
	AddOK=true
else
	MsgBox "Please enter a Firm Code"
	AddOK=false
end if
if AddOK=true then
	for j=1 to tIndex
		if document.all("FirmCode").item(j).Value=FirmCode then
			AddOK=false
			MsgBox "The Firm Code is existed!"
		end if
	next
end if
if AddOK=true then
	document.form1.action="edit_freight.asp?add=yes" & "&tNo=" & TranNo  & "&WindowName=" & window.name
	Document.form1.target = "_self"

	document.form1.method="POST"
	form1.submit()
end if
End Sub
Sub DeletePort(PortCode)
	ok=MsgBox ("Are you sure you want to delete this port?" & chr(13) & "Continue?",36,"Message")
	if ok=6 then	
		document.form1.action="edit_freight.asp?delete=yes&dFirmCode=" & PortCode  & "&WindowName=" & window.name
	Document.form1.target = "_self"

		document.form1.method="POST"
		form1.submit()
	end if
End Sub
Sub UpdatePort(rNo)
	document.form1.action="edit_freight.asp?update=yes&rNo=" & rNo  & "&WindowName=" & window.name 
	Document.form1.target = "_self"

	document.form1.method="POST"
	form1.submit()
End Sub
Sub MenuMouseOver()
NoItem=document.form1.hNoItem.Value
for i=1 to NoItem+1
	document.all("Country").item(i).style.visibility="hidden"
	document.all("State").item(i).style.visibility="hidden"
next
End Sub
Sub MenuMouseOut()
NoItem=document.form1.hNoItem.Value
for i=1 to NoItem+1
	document.all("Country").item(i).style.visibility="visible"
	document.all("State").item(i).style.visibility="visible"
next
End Sub
--->
</script>

<!-- //for Tooltip// -->

<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>

<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
