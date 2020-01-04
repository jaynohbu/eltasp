<%@ LANGUAGE = VBScript %>
<html>
<head>
<title>Delivery Confirm</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<!--  #INCLUDE FILE="../include/connection.asp" -->
<style type="text/css">
<!--
.text {
	font-family:Verdana, Arial, Helvetica, sans-serif;
	font-size:0.85em;
}
.style1 {color: #CC0000}
-->
</style>
</head>

<!--  #INCLUDE FILE="../include/header.asp" -->
     <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #INCLUDE FILE="../include/MakeAgentPreAlertPDFFile.asp" -->
<!--  #INCLUDE FILE="../include/clsUpload.asp"-->
<!--  #INCLUDE FILE="../include/SaveBinaryFile.asp" -->

<%
Dim aMAWB(2000),aAgentName(32),aAgentNo(32),aAgentEmail(32),aAgentCheck(32),aAgentCC(32),aAgentMSG(32)
Dim aHAWB(32,64),aHAWBCheck(32,64),aInvoice(32),aManifest(32),aHAWBIndex(32),aInvoiceAmt(32),aInvoiceCheck(32),aManifestCheck(32)
Dim aStmtCheck(32)
Dim aOnlineAlertCheck(32),aAgentELTAcct(32)
Dim aShipper(32,64),aConsignee(32,64)
Dim aShipperName(32),aShipperNo(32),aShipperEmail(32),aShipperCheck(32),aShipperCC(32),aShipperMSG(32)


'////////////////////////////////////////////////////////////////////////////////////////// by ig
Dim aShipperHAWB(32,64),aShipperHAWBCheck(32,64),aShipperHAWBIndex(32)
Dim aShipperInvoice(32,64),aShipperInvoiceCheck(32,64),aShipperInvoiceIndex(32)
Dim aShipperMAWB(1),aShipperMAWBIndex(1),sIndex,aIndex,shIndex,ahIndex,mIndex
Dim vCarrier,vFileNo,vFLT,vETD,vETA,vDepPort,vArrPort

Dim objUpload
Dim strFileName
Dim objConn
Dim objRs
Dim lngFileID
Dim rs,rs1,SQL

'////////////////////////////////////////////////////////////////////////////////////////// by ig

Dim aShipperSubject(32),aAgentSubject(32)
Dim aShipperFileCheck(32,128),aShipperFileURL(32,128),aShipperFileIndex(32),aShipperFileName(32,128)
Dim aMAWBAgentCheck(32),aMAWBShipperCheck(32)
Dim aAgentFileCheck(32,128),aAgentFileURL(32,128),aAgentFileIndex(32),aAgentFileName(32,128)
Dim vMAWB,vAgent,vCC,vSubject,vYourName,vYourEmail,vMSG
Dim aSendInfo(32)
Dim MasterAgentNo,MasterAgentName,MasterAgentPhone
Dim NoItem,aShipperPDFName(32),aConsigneeCheck(32),PDFNameForDB,testFileSize,fileSizeLimit

Dim Mail
fileSizeLimit = 30000000

%>

<%
Send=Request.QueryString("Send")
Edit=Request.QueryString("Edit")
UP=Request.QueryString("UP")
RM=Request.QueryString("RM")
dFileName=Request.QueryString("dFileName")
vEMPHAWB=Request.QueryString("EMPHAWB")
%>

<%
Set rs=Server.CreateObject("ADODB.Recordset")
Set rs1=Server.CreateObject("ADODB.Recordset")
%>

<%
	rEdit=Request.QueryString("rEdit")
	if rEdit = "yes" then
		vMAWB = Request.QueryString("rMAWB")
	end if
%>

<%
if Edit="yes" or Send="yes" or UP="yes" Or RM="yes" then
' Instantiate Upload Class
	Set objUpload = New clsUpload
	vMAWB=objUpload("lstMAWB").Value
	vMAWB=Mid(vMAWB,1,len(vMAWB)-2)
	vYourName=objUpload("txtYourName").Value
	vYourName=Mid(vYourName,1,len(vYourName)-2)
	vYourEmail=objUpload("txtYourEmail").Value
	vYourEmail=Mid(vYourEmail,1,len(vYourEmail)-2)
end if
%>

<%
if Edit="yes" then
	SQL= "select * from users where elt_account_number=" & elt_account_number & " and userid=" & user_id
	rs.Open SQL, eltConn, , , adCmdText
	if Not rs.EOF then
		vYourName=rs("user_fname") & " " & rs("user_lname")
		vYourEmail=rs("user_email")
	end if
	rs.Close
	SQL= "select dba_name from agent where elt_account_number=" & elt_account_number
	rs.Open SQL, eltConn, , , adCmdText
	if Not rs.EOF then
		vFF=rs("dba_name")
	end if
	rs.Close
	vSubject="Pre-Alert: " & vFF & " MAWB:" & vMAWB
elseif Send="yes" or UP="yes" Or RM="yes" then
	vFF=objUpload("hExportAgent").Value
end if
%>

<%
if Send = "yes" and vEMPHAWB = "yes" then
       sIndex=1
       shIndex=1
       aShipperName(0) = objUpload("txtShipperName" & 0).Value
       aShipperMAWB(0)=vMAWB
	  aShipperNo(0) = objUpload("hShipperNo" & 0).Value
	  aShipperNo(0) = Mid(aShipperNo(0),1,len(aShipperNo(0))-2)
       aShipperCheck(0)=Mid(objUpload("cShipperCheck" & 0).Value,1,1)
       aShipperSubject(0)=objUpload("txtShipperSubject" & 0).Value
       aShipperSubject(0)=Mid(aShipperSubject(0),1,len(aShipperSubject(0))-2)
       aShipperEmail(0)=objUpload("txtShipperEmail" & 0).Value
       aShipperEmail(0)=Mid(aShipperEmail(0),1,len(aShipperEmail(0))-2)
       aShipperCC(0)=objUpload("txtShipperCC" & 0).Value
       aShipperCC(0)=Mid(aShipperCC(0),1,len(aShipperCC(0))-2)
       aShipperMSG(0)=objUpload("txtShipperMSG" & 0).Value
        aMAWBShipperCheck(0)=objUpload("cShipperMAWBCheck" & 0).Value
        
'// fix by Joon on jan/31/2007 /////////////////////////////////////////////////////////////
        if len(aMAWBShipperCheck(0))>2 Then
            aMAWBShipperCheck(0)=Mid(aMAWBShipperCheck(0),1,len(aMAWBShipperCheck(0))-2)
        End If
'///////////////////////////////////////////////////////////////////////////////////////////       

       for iii = 0 to 4
       	if Not objUpload("cShipperInvoiceCheck" & 0 & "," & iii).Value = NULL then
			aShipperInvoiceCheck(0,iii)=Mid(objUpload("cShipperInvoiceCheck" & 0 & "," & iii).Value,1,1)
		end if
       next

	  Call Get_Invoice_for_MAWB(0,0)
end if

if Not vMAWB="" and rEdit="" then
  if Not vEMPHAWB = "yes" then
	  Call Get_Normal_Shipping_Data
	  Call Get_Attached_File
  else
	  Call Get_Attached_File
  end if

end if

Call Get_MAWB_NUMBER

'send email to all Shippers

'ShipperNoItem=Request("hShipperNoItem")
if Edit="yes" or Send="yes" or UP="yes" or RM="yes" then
	ShipperNoItem=objUpload("hShipperNoItem").Value
	if Not ShipperNoItem="" then
		ShipperNoItem=Mid(ShipperNoItem,1,len(ShipperNoItem)-2)
		NoItem = ShipperNoItem
	end if
end if

if ShipperNoItem="" then ShipperNoItem=0

if Send="yes" And ShipperNoItem>0 then
	'response.buffer=True
	Set PDF = Server.CreateObject("APToolkit.Object")
	Set fso = Server.CreateObject("Scripting.FileSystemObject")
	for m=0 to ShipperNoItem-1
		AttachedFileName=""
		Attachment=""
		
		If aShipperNo(m) = "" Then
		    aShipperNo(m) = 0
		End If

		If Not aShipperNo(m) = "" And aShipperCheck(m)="Y" then
			AttachedFileName=temp_path & "\Eltdata\" & elt_account_number & "\shippermail" & aShipperNo(m) & ".pdf"
			PDFNameForDB=elt_account_number & "\shippermail" & aShipperNo(m) & ".pdf"
			r=PDF.OpenOutputFile(AttachedFileName)
' insert mawb to pdf file
			'aMAWBShipperCheck(m)=Request("cMAWBShipperCheck" & m)
			if Not aMAWBShipperCheck(m)="" and Not vMAWB="" then
				Call InsertMAWBIntoPDF(vMAWB,"SHIPPER")
				Attachment="Y"
			end if
' insert hawb to pdf file
			for n=0 to aShipperHAWBIndex(m)
				'aShipperHAWBCheck(m,n)=Request("cShipperHAWBCheck" & m & "," & n)
				if aShipperHAWBCheck(m,n)="Y" then
					HAWBtmp=aShipperHAWB(m,n)
					Call InsertHAWBIntoPDF(HAWBtmp,"SHIPPER")
					Attachment="Y"
				end if
			next

' insert invoice to pdf file  // by ig
			for n=0 to aShipperInvoiceIndex(m)
				if aShipperInvoiceCheck(m,n)="Y" then
					Invoicetmp=aShipperInvoice(m,n)
					Call InsertInvoiceIntoPDF(aShipperInvoice(m,n))
					Attachment="Y"
				end if
			next

			PDF.CloseOutputFile

			Set Mail=Server.CreateObject("Persits.MailSender")
			MailServer=Request.ServerVariables("SERVER_NAME")
			Mail.Host = MailHost


'////////////////////////////////////////////////////////////
			Mail.From="shippingNotice@e-logitech.net"
			Mail.FromName="Air Export Shipping Notice"		

fHTML = True

If fHTML = True then
'// HTML Format
			aShipperMSG(m) = Replace(aShipperMSG(m),Chr(13),"</br>")	
			str="<html xmlns='http://www.w3.org/1999/xhtml><head><meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' /><title>AIR EXPORT SHIPPING NOTICE</title><style type='text/css'><!--.text {font-family: Verdana, Arial, Helvetica, sans-serif;	font-size: 0.85em;}--></style></head><body><p class='text'><font color='#f39003'><strong>AIR EXPORT SHIPPING NOTICE</strong></font></p><p class='text'>"
			str=str & aShipperMSG(m)
			str=str & "</p><br><br><br><P class='text'>This message was sent by E-LOGISTICS TECHNOLOGY on behalf of <a href='mailto:" & vYourEmail & "'>" & vYourName & "</a>.<br>"
			str=str & "If you would like to reply to this message, please click on the following link:<br /><a href='mailto:"&vYourEmail&"'>" & vYourEmail & "</a>.</P><a href='http://e-logitech.net' target='_blank'><img src='http://www.e-logitech.net:8080/elt_email/images/powered_logo.gif' width='123' height='50' border='0' /></a></body></html>"
			Mail.IsHTML=True
else
'// Plain Text
			str=aShipperMSG(m)
End if

			Mail.Body=str
			Mail.Subject=aShipperSubject(m)

'////////////////////////////////////////////////////////////
			
			Call ADD_TO_MAIL(Mail, checkBlank(aShipperEmail(m),""))
			Call ADD_CC_MAIL(Mail, checkBlank(aShipperCC(m),""))

			if Not AttachedFileName="" And Attachment="Y" then
				Mail.AddAttachment AttachedFileName
				aShipperPDFName(m) = "shippermail" & aShipperNo(m) & ".pdf"
				for n=0 to aShipperFileIndex(m)-1
					vDest=temp_path & "\Eltdata\" & elt_account_number & "\" & aShipperNo(m)
					if aShipperFileCheck(m,n)="Y" then
						Call SaveBinaryFile(aShipperNo(m),aShipperFileName(m,n))
						testFileSize = FileLen(vDest & "\" & aShipperFileName(m,n))
						If testFileSize < fileSizeLimit Then
						    Mail.AddAttachment vDest & "\" & aShipperFileName(m,n)
						Else
%>

        <p class="text" align="center"><%=aAgentFileName(m,n) %> exceeded filesize limit (<%=testFileSize %>/3MB)</p>

<%
                            aShipperFileName(m,n) = ""
                        End If
					end if
				next
			end if
		    On Error Resume Next:
		    Mail.Send	
			error_num = 0
			error_num = Err.Number
			If error_num <> 0 Then
			    aSendInfo(m)= "Error: " & error_num
			Else
			    aSendInfo(m)= "Sent"
			End If
%>

<%
  if m = 0  then
%>

<table width="100%" border="0" cellpadding="0" cellspacing="0">

<%
  end if
%>

  <tr>
    <td >
  <tr>
	<td >
      
    <%
			if error_num>0 then
    %>

  <tr>
    <td align="center" class="text" ><span class="style1">eMail
      was not sent!</span></td>

    <p class="text" align="center"><%
				Response.Write("Shipper " & aShipperName(m) & " Failed with Error # " & CStr(Err.Number) & " " & Err.Description & "")
				Err.Clear
	%></p>

	</td>
  </tr>

  <%
			else

	%>

  <tr>
    <td align="center" class="text" ><font color="#3366CC">eMail
      was sent successfully!</font></td>
  </tr></td></tr>
  <tr>
    <td align="center">
      <%
				Response.Write("(Shipper: " & aShipperName(m)  & ")")
%>
    </td>
  </tr>
  <%
			end if
%>
<%
			Set Mail=Nothing
		end if
	next
	set PDF=nothing
end if
%>

  <tr>
    <td align="center">&nbsp;</td>
  </tr>
  <tr>
    <td align="center"><input name="CloseMe" type="button" onClick="javascript:window.close();" value="Close"></td>
  </tr>
</table>

<%
  Set rs  = Nothing
  Set rs1 = Nothing
%>

<%

Sub Get_MAWB_NUMBER

SQL= "select * from mawb_number where elt_account_number = " & elt_account_number & " and status='B' order by mawb_no"
rs.Open SQL, eltConn, , , adCmdText
mIndex=0

Do While Not rs.EOF
	aMAWB(mIndex)=rs("mawb_no")
	if vMAWB=aMAWB(mIndex) then
		vCarrier=rs("carrier_desc")
		vFileNo=rs("file#")
		vFLT=rs("flight#1")
		vETD=rs("etd_date1")
		vETA=rs("eta_date1")
		vDepPort=rs("origin_port_id")
		vArrPort=rs("dest_port_id")
	end if
	rs.MoveNext
	mIndex=mIndex+1
Loop
rs.Close
End Sub

Sub Get_Normal_Shipping_Data

'get master agent info
	SQL="select a.master_agent,b.dba_name,b.business_phone from mawb_master a, organization b "
	SQL=SQL & "where a.elt_account_number=b.elt_account_number and a.elt_account_number = " & elt_account_number & " and a.master_agent=b.org_account_number and a.MAWB_NUM = '" & vMAWB & "'"
	rs.Open SQL, eltConn, , , adCmdText

	if Not rs.EOF then
		MasterAgentNo=rs("master_agent")
		MasterAgentName=rs("dba_name")
		MasterAgentPhone=rs("business_phone")
	end if
	rs.close

	SQL= "select a.agent_name,a.agent_no,a.shipper_name,a.consignee_name,hawb_num,b.agent_elt_acct,b.owner_email,b.edt from hawb_master a, organization b where a.elt_account_number=b.elt_account_number and a.elt_account_number = " & elt_account_number & " and a.agent_no=b.org_account_number and a.MAWB_NUM = '" & vMAWB & "' order by a.agent_name,a.hawb_num"
	rs.Open SQL, eltConn, , , adCmdText
	aIndex=0
	hIndex=0
	LastAgent=""
	Do While Not rs.EOF
		vHAWB=rs("hawb_num")
		vShipper=rs("shipper_name")
		vConsignee=rs("consignee_name")
		vAgentName=rs("agent_name")
		vAgentNo=rs("agent_no")
		vAgentEmail=rs("owner_email")
		vAgentELTAcct=rs("agent_elt_acct")
		if IsNull(vAgentELTAcct) or vAgentELTAcct="" then vAgentELTAcct=0
		vEDTEnable=rs("edt")
		if Not LastAgent=vAgentName then
			hIndex=0
			aHAWB(aIndex,hIndex)=vHAWB
			aShipper(aIndex,hIndex)=vShipper
			aConsignee(aIndex,hIndex)=vConsignee
			if Edit="yes" then
				aHAWBCheck(aIndex,hIndex)="Y"
			else
				aHAWBCheck(aIndex,hIndex)=Mid(objUpload("cHAWBCheck" & aIndex & "," & hIndex).Value,1,1)
			end if
			aHAWBIndex(aIndex)=hIndex
			aAgentName(aIndex)=vAgentName
			aAgentNo(aIndex)=vAgentNo
			aAgentELTAcct(aIndex)=vAgentELTAcct
			if Not MasterAgentNo="" and not vAgentNo="" then
				if Not cLng(MasterAgentNo)=cLng(vAgentNo) then
					aAgentMSG(aIndex)="Master agent is " & MasterAgentName & chr(10) & "Phone# " & MasterAgentPhone
				end if
			end if
			if Edit="yes" then
'				aAgentCheck(aIndex)="Y"
'				if vEDTEnable="Y" then
'					aOnlineAlertCheck(aIndex)="Y"
'				end if
'				aAgentSubject(aIndex)=vSubject
'				aAgentEmail(aIndex)=vAgentEmail
			else
'				aAgentCheck(aIndex)=Mid(objUpload("cAgentCheck" & aIndex).Value,1,1)
'				aOnlineAlertCheck(aIndex)=Mid(objUpload("cOnlineAlertCheck" & aIndex).Value,1,1)
'				aAgentSubject(aIndex)=objUpload("txtAgentSubject" & aIndex).Value
'				aAgentSubject(aIndex)=Mid(aAgentSubject(aIndex),1,len(aAgentSubject(aIndex))-2)
'				aAgentEmail(aIndex)=objUpload("txtAgentEmail" & aIndex).Value
'				aAgentEmail(aIndex)=Mid(aAgentEmail(aIndex),1,len(aAgentEmail(aIndex))-2)
'				aAgentCC(aIndex)=objUpload("txtAgentCC" & aIndex).Value
'				aAgentCC(aIndex)=Mid(aAgentCC(aIndex),1,len(aAgentCC(aIndex))-2)
'				aAgentMSG(aIndex)=objUpload("txtMSG" & aIndex).Value
'				aAgentMSG(aIndex)=Mid(aAgentMSG(aIndex),1,len(aAgentMSG(aIndex))-2)
			end if
			LastAgent=vAgentName
'get invoice
			SQL= "select distinct invoice_no from invoice where elt_account_number = " & elt_account_number & " and MAWB_NUM = '" & vMAWB & "' and customer_number=" & vAgentNo
'			response.write SQL
			rs1.Open SQL, eltConn, , , adCmdText
			sIIndex=0

			Do While Not rs1.EOF
				aShipperInvoice(aIndex,sIIndex)=rs1("invoice_no")
				if Edit="yes" then
					aShipperInvoiceCheck(aIndex,sIIndex)="Y"
				else
					aShipperInvoiceCheck(aIndex,sIIndex)=Mid(objUpload("cShipperInvoiceCheck" & aIndex & "," & sIIndex).Value,1,1)
				end if
	                 sIIndex=sIIndex+1
	                 rs1.MoveNext
			Loop
                 aShipperInvoiceIndex(aIndex)=sIIndex
			rs1.close

'get Stmt
'			SQL= "select invoice_no,amount_charged from invoice where elt_account_number = " & elt_account_number & " and MAWB_NUM = '" & vMAWB & "' and customer_number=" & vAgentNo
'			rs1.Open SQL, eltConn, , , adCmdText
'			if Not rs1.EOF then
'				aInvoice(aIndex)=rs1("invoice_no")
'				aInvoiceAmt(aIndex)=rs1("amount_charged")
'			end if
'			if Edit="yes" then
'				aInvoiceCheck(aIndex)="Y"
'				aStmtCheck(aIndex)="Y"
'			else
'				aInvoiceCheck(aIndex)=Mid(objUpload("cInvoiceCheck" & aIndex).Value,1,1)
'				aStmtCheck(aIndex)=Mid(objUpload("cStmtCheck" & aIndex).Value,1,1)
'			end if
'			rs1.close

'manifest
'			aManifest(aIndex)="MAWB=" & vMAWB & "&Agent=" & vAgentNo & "&MasterAgentNo=" & MasterAgentNo & "&AgentName=" & vAgentName & "&MasterAgentName=" & MasterAgentName & "&MasterAgentPhone=" & MasterAgentPhone
'			if Edit="yes" then
'				aManifestCheck(aIndex)="Y"
'				aMAWBAgentCheck(aIndex)="Y"
'			else
'				aManifestCheck(aIndex)=Mid(objUpload("cManifestCheck" & aIndex).Value,1,1)
'				aMAWBAgentCheck(aIndex)=Mid(objUpload("cMAWBAgentCheck" & aIndex).Value,1,1)
'			end if
			aIndex=aIndex+1
			hIndex=hIndex+1
		else
			aHAWB(aIndex-1,hIndex)=vHAWB
			aShipper(aIndex-1,hIndex)=vShipper
			aConsignee(aIndex-1,hIndex)=vConsignee
			if Edit="yes" then
				aHAWBCheck(aIndex-1,hIndex)="Y"
			else
				aHAWBCheck(aIndex-1,hIndex)=Mid(objUpload("cHAWBCheck" & aIndex-1 & "," & hIndex).Value,1,1)
			end if
			aHAWBIndex(aIndex-1)=hIndex
			hIndex=hIndex+1
		end if
		rs.MoveNext
	Loop
	rs.close

'get info for shipper
	SQL= "select a.shipper_name,a.shipper_account_number,hawb_num,a.ci,b.owner_email from hawb_master a, organization b where a.elt_account_number=b.elt_account_number and a.elt_account_number = " & elt_account_number & " and a.shipper_account_number=b.org_account_number and a.MAWB_NUM = '" & vMAWB & "' order by a.shipper_account_number,a.hawb_num"
	rs.Open SQL, eltConn, , , adCmdText
	sIndex=0
	shIndex=0
	LastShipper=""

'/////////////////////////
if  Not rs.EOF then
'/////////////////////////
  	Do While Not rs.EOF
		vHAWB=rs("hawb_num")
		vShipperName=rs("shipper_name")
		vShipperNo=rs("shipper_account_number")
		vShipperEmail=rs("owner_email")
		vShipperSubject=rs("ci")
		if Not LastShipper=vShipperName then
			shIndex=0
			aShipperHAWB(sIndex,shIndex)=vHAWB
			aShipperName(sIndex)=vShipperName
			if Edit="yes" then
				aShipperHAWBCheck(sIndex,shIndex)="Y"
			else
				aShipperHAWBCheck(sIndex,shIndex)=Mid(objUpload("cShipperHAWBCheck" & sIndex & "," & shIndex).Value,1,1)
			end if

			aShipperHAWBIndex(sIndex)=shIndex
			aShipperNo(sIndex)=vShipperNo
			if Edit="yes" then
				aShipperCheck(sIndex)="Y"
				aShipperEmail(sIndex)=vShipperEmail
				aShipperSubject(sIndex)="Shipping Advice: " & vFF & " " & vShipperSubject
				aMAWBShipperCheck(sIndex)="Y"
			else
				aShipperCheck(sIndex)=Mid(objUpload("cShipperCheck" & sIndex).Value,1,1)
				aShipperSubject(sIndex)=objUpload("txtShipperSubject" & sIndex).Value
				aShipperSubject(sIndex)=Mid(aShipperSubject(sIndex),1,len(aShipperSubject(sIndex))-2)
				aShipperEmail(sIndex)=objUpload("txtShipperEmail" & sIndex).Value
				aShipperEmail(sIndex)=Mid(aShipperEmail(sIndex),1,len(aShipperEmail(sIndex))-2)
				aShipperCC(sIndex)=objUpload("txtShipperCC" & sIndex).Value
				aShipperCC(sIndex)=Mid(aShipperCC(sIndex),1,len(aShipperCC(sIndex))-2)
				aShipperMSG(sIndex)=objUpload("txtShipperMSG" & sIndex).Value
				aMAWBShipperCheck(sIndex)=Mid(objUpload("cMAWBShipperCheck" & sIndex).Value,1,1)
			end if
			LastShipper=vShipperName

'get invoice
			SQL= "select distinct invoice_no from invoice where elt_account_number = " & elt_account_number & " and MAWB_NUM = '" & vMAWB & "'"
'			response.write SQL
			rs1.Open SQL, eltConn, , , adCmdText
			sIIndex=0

			Do While Not rs1.EOF
				aShipperInvoice(sIndex,sIIndex)=rs1("invoice_no")
				if Edit="yes" then

					aShipperInvoiceCheck(sIndex,sIIndex)="Y"
				else
					aShipperInvoiceCheck(sIndex,sIIndex)=Mid(objUpload("cShipperInvoiceCheck" & sIndex & "," & sIIndex).Value,1,1)
				end if
	                 sIIndex=sIIndex+1
	                 rs1.MoveNext
			Loop
                 aShipperInvoiceIndex(sIndex)=sIIndex
			rs1.close

			sIndex=sIndex+1
			shIndex=shIndex+1
		else
			aShipperHAWB(sIndex-1,shIndex)=vHAWB
			aShipperName(sIndex-1)=vShipperName
			aShipperSubject(sIndex-1)=aShipperSubject(sIndex-1) & " " & vShipperSubject
			if Edit="yes" then
				aShipperHAWBCheck(sIndex-1,shIndex)="Y"
			else
				aShipperHAWBCheck(sIndex-1,shIndex)=Mid(objUpload("cShipperHAWBCheck" & sIndex-1 & "," & shIndex).Value,1,1)
			end if
			aShipperHAWBIndex(sIndex-1)=shIndex
			shIndex=shIndex+1
		end if
		rs.MoveNext
	Loop
	rs.close

'///////////////////////////
else
'///////////////////////////

		rs.close

		SQL= "select shipper_name,shipper_account_number from mawb_master where  elt_account_number = " & elt_account_number & " and  MAWB_NUM = '" & vMAWB & "' "
		rs.Open SQL, eltConn, , , adCmdText
		if not rs.EOF then
			vShipperName=rs("shipper_name")
			vShipperNo=rs("shipper_account_number")
		end if
		rs.close
		if not vShipperNo="" then 
		if  len(vShipperNo) < 5 then
			SQL= "select owner_email from organization where elt_account_number = " & elt_account_number & " and org_account_number = '" &  vShipperNo & "'"
			rs.Open SQL, eltConn, , , adCmdText
			vShipperEmail=rs("owner_email")
			rs.close
			aShipperEmail(0) = vShipperEmail
		else
			vShipperEmail=""
		end if
		end if

           Call Get_Invoice_For_MAWB(0,0)

		sIndex=sIndex+1
		shIndex=shIndex+1
		aShipperName(0) = vShipperName
		aShipperNo(0) = vShipperNo

		aShipperCheck(0)="Y"
		aShipperEmail(0)=vShipperEmail
		aShipperSubject(0)="Shipping Advice: " & vFF & " " & vShipperSubject
		aMAWBShipperCheck(0)="Y"
		aShipperMAWB(0)=vMAWB
		aMAWBShipperCheck(0)="Y"

end if

End Sub

Sub Get_Invoice_For_MAWB(ssIndex,ssIIndex)

  SQL= "select distinct invoice_no from invoice where elt_account_number = " & elt_account_number & " and MAWB_NUM = '" & vMAWB & "'"
  rs1.Open SQL, eltConn, , , adCmdText

  Do While Not rs1.EOF
        aShipperInvoice(ssIndex,ssIIndex)=rs1("invoice_no")
        if Edit="yes" then
              aShipperInvoiceCheck(ssIndex,ssIIndex)="Y"
        else
              aShipperInvoiceCheck(ssIndex,ssIIndex)=Mid(objUpload("cShipperInvoiceCheck" & ssIndex & "," & ssIIndex).Value,1,1)
        end if
       ssIIndex=ssIIndex+1
       rs1.MoveNext
  Loop
  aShipperInvoiceIndex(ssIndex)=ssIIndex
  rs1.close

End SUb

Sub Get_Attached_File

'update shipper file check status
'	if Not Edit="yes" then
        if not vShipperNo="" then  
		for i=0 to sIndex-1
			SQL= "select file_checked from user_files where elt_account_number=" & elt_account_number & " and org_no=" & aShipperNo(i)
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			afIndex=0
			Do while Not rs.EOF
				vFileChecked=Mid(objUpload("cShipperFileCheck" & i & "," & afIndex).Value,1,1)
				rs("file_checked")=vFileChecked
				rs.Update
				rs.MoveNext
				afIndex=afIndex+1
			loop
			rs.Close
		next
	end if

'uploading file
	if UP="yes" then
		UpOrgNo=Request.QueryString("UpOrgNo")
		if Not UpOrgNo="" then
			UpFileName=objUpload.Fields("File" & UpOrgNo).FileName
			SQL= "select * from user_files where elt_account_number =" & elt_account_number & " and org_no=" & UpOrgNo & " and file_name='" & UpFileName & "'"
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			If rs.EOF=true Then
				rs.AddNew
				rs("elt_account_number") = elt_account_number
				rs("org_no") =UpOrgNo
				rs("file_name") = UpFileName
			end if
			rs("file_size") = objUpload.Fields("File" & UpOrgNo).Length
			rs("file_type") = objUpload.Fields("File" & UpOrgNo).ContentType
			rs("file_content").AppendChunk objUpload("File" & UpOrgNo).BLOB & ChrB(0)
			rs("file_checked")="Y"
			rs("in_dt") = Now
			rs.Update
			rs.Close
		end if
	end if
	if RM="yes" then
		UpOrgNo=Request.QueryString("UpOrgNo")
		SQL= "delete from user_files where elt_account_number = " & elt_account_number & " and org_no=" & UpOrgNo & " and file_name='" & dFileName & "'"
		eltConn.Execute SQL
	end if

' get shipper attached files
    IF NOT vshipperNo="" then
       for i=0 to sIndex-1
         SQL= "select file_name,file_checked from user_files where elt_account_number=" & elt_account_number & " and org_no=" & aShipperNo(i)
         rs.Open SQL, eltConn, , , adCmdText
         sfIndex=0
         Do while Not rs.EOF
               vFileName=rs("file_name")
               aShipperFileURL(i,sfIndex)= "/ASP/include/viewfile.asp?OrgNo=" & aShipperNo(i) & "&FileName=" & vFileName
               aShipperFileName(i,sfIndex)=vFileName
               aShipperFileCheck(i,sfIndex)=rs("file_checked")
               rs.MoveNext
               sfIndex=sfIndex+1
         loop
         rs.Close
         aShipperFileIndex(i)=sfIndex
       next
       end if
End Sub

Call UpdateEmailHistory("A","E","Shipping Notice")
%>
<!-- #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!-- #INCLUDE FILE="../include/emailTracking.inc" -->
<!-- #INCLUDE FILE="../include/StatusFooter.asp" -->

</html>