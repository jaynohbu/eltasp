<!--  #INCLUDE FILE="../include/transaction.txt" -->
<!--  #INCLUDE FILE="../include/connection.asp" -->
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<meta name="ProgId" content="FrontPage.Editor.Document">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">

<title>File Download</title>
</head>
<!--  #INCLUDE FILE="../include/header.asp" -->
<%
Dim aAllOrgInfo(10000)
Dim rs,SQL,vLastUpdate
Set rs = Server.CreateObject("ADODB.Recordset")
	SQL= "select * from organization where elt_account_number = " & elt_account_number & " and account_status<>'D' order by dba_name"
rs.Open SQL, eltConn, , , adCmdText
DL="#@"
aIndex=0
cIndex=0
sIndex=0
vIndex=0
nIndex=0
allIndex=0
Do While Not rs.EOF 
	cName=rs("DBA_NAME")
	cAcct=cLng(rs("org_account_number"))
	cAddress=rs("business_address")
	cCity=rs("business_city")
	cState=rs("business_State")
	cZip=rs("business_Zip")
	cCountry=rs("business_Country")
	cPhone=rs("business_phone")
	IsAgent=rs("is_agent")
	IsShipper=rs("is_shipper")
	IsConsignee=rs("is_consignee")
	IsVendor=rs("is_vendor")
	if Not Trim(cState)="" then
		AddressInfo=cAcct & DL & IsAgent & DL & IsConsignee & DL & IsShipper & DL & IsVendor & DL & cName & DL & cAddress & DL & cCity & "," & cState & " " & cZip & "," & cCountry & DL & cPhone
	else
		AddressInfo=cAcct & DL & IsAgent & DL & IsConsignee & DL & IsShipper & DL & IsVendor & DL & cName & DL & cAddress & DL & cCity & "," & cCountry & DL & cPhone
	end if
	aAllOrgInfo(allIndex)=AddressInfo
	allIndex=allIndex+1
	rs.MoveNext
Loop	
rs.Close
%>

<body>
<form name="form1">

<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0" >
  <tr>
    <td width="6%">&nbsp;</td>
    <td width="88%">&nbsp;</td>
    <td width="6%">&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td><input name="msgText" type="text" style="border:0; width:100%; border-style:none" value="" class="shorttextfield" ></td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td align="center">&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td>&nbsp;</td>
    <td align="center"><input name="CloseMe" type="button" onClick="javascript:parent.closeMe();" value="Close"></td>
    <td>&nbsp;</td>
  </tr>
</table>
<input type=hidden id="AllOrgInfo">
<% for i=0 to allIndex-1 %>
<input type=hidden id="AllOrgInfo" value="<%= aAllOrgInfo(i) %>">
<% next %>
</form>
</body>

<script language="VBScript">
<!--
Set fso = CreateObject("Scripting.FileSystemObject")
If Not fso.FolderExists("C:\TEMP") Then
	Set f = fso.CreateFolder("C:\TEMP")
End If
If Not fso.FolderExists("C:\TEMP\EltData") Then
	Set f = fso.CreateFolder("C:\TEMP\EltData")
End If
allIndex=<%= allIndex %>
if allIndex>0 then
	Set OutFile=fso.CreateTextFile("C:\TEMP\EltData\AllOrgInfo.elt", True)
	for i=1 to allIndex
		AllOrgInfo=document.all("AllOrgInfo").item(i).value
		OutFile.WriteLine(AllOrgInfo)
	next
	OutFile.Close
	Set OutFile=Nothing
end if
Set fso=Nothing
document.form1.msgText.value = "Organization file was downloaded successfully!"
window.parent.closeDownloading()
-->
</script>
</html>
