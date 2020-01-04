<%@ LANGUAGE = VBScript %>
<html>
<head>
<title>Pre-Alert</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<!--  #INCLUDE FILE="../include/connection.asp" -->

<!-- /Start of Combobox/ -->
<script type="text/javascript">
<!--
// var ComboBoxes =  new Array('list1','list2','list3',.....);
// modified by Joon On Joon On Dec-8-2006 :  lstHAWB added
var ComboBoxes =  new Array('lstMAWB','lstHAWB');
// -->
</script>
<script language='JScript' src='../Include/iMoonCombo.js'></script>
<!-- /End of Combobox/ -->

<style type="text/css">
<!--
.style1 {color: #663366}
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
a:hover {
	color: #CC3300;
}
-->
</style>
</head>

<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #INCLUDE FILE="../include/MakeAgentPreAlertPDFFile.asp" -->
<!--  #INCLUDE FILE="../include/clsUpload.asp"-->
<!--  #INCLUDE FILE="../include/SaveBinaryFile.asp" -->


<%
Dim rs,SQL
Dim aAgentName(32),aAgentNo(32),aAgentEmail(32),aAgentCheck(32),aAgentCC(32),aAgentMSG(32)
Dim aHAWB(32,64),aHAWBCheck(32,64),aInvoice(32),aManifest(32),aHAWBIndex(32),aInvoiceAmt(32),aInvoiceCheck(32),aManifestCheck(32)
Dim aStmtCheck(32)
DIM aAgentInvoice(32),aAgentnvoiceCheck(32)
Dim aOnlineAlertCheck(32),aAgentELTAcct(32)
Dim aShipper(32,64),aConsignee(32,64)
Dim aShipperName(32),aShipperNo(32),aShipperEmail(32),aShipperCheck(32),aShipperCC(32),aShipperMSG(32)
Dim aShipperHAWB(32,64),aShipperHAWBCheck(32,64),aShipperInvoice(32),aShipperHAWBIndex(32),aShipperInvoiceCheck(32)
Dim aShipperSubject(32),aAgentSubject(32)
Dim aShipperFileCheck(32,128),aShipperFileURL(32,128),aShipperFileIndex(32),aShipperFileName(32,128)
Dim aMAWBAgentCheck(32),aMAWBShipperCheck(32)
Dim aAgentFileCheck(32,128),aAgentFileURL(32,128),aAgentFileIndex(32),aAgentFileName(32,128)
Dim vMAWB,vAgent,vCC,vSubject,vYourName,vYourEmail,vMSG
Dim aSendInfo(32)
Dim MasterAgentNo,MasterAgentName,MasterAgentPhone,Recent


'// Added by Joon On Dec-8-2006 /////////////////////
Dim vHAWB,hawb_list,rMAWB,mawb_list,fileNo_list,mIndex
'////////////////////////////////////////////////////

Send=Request.QueryString("Send")
Edit=Request.QueryString("Edit")
UP=Request.QueryString("UP")
RM=Request.QueryString("RM")
dFileName=Request.QueryString("dFileName")

'// added by Joon On Joon On Dec-8-2006
rMAWB=Request.QueryString("rMAWB")

if Edit="yes" or Send="yes" or UP="yes" Or RM="yes" then
	Dim objUpload
	Dim strFileName
	Dim objConn
	Dim objRs
	Dim lngFileID

' Instantiate Upload Class
	Set objUpload = New clsUpload
	vMAWB=checkBlank(objUpload("lstMAWB").Value,"")
	If vMAWB <> "" Then
	    vMAWB=Mid(vMAWB,1,len(vMAWB)-2)
	End If
'// Added by Joon On Dec-8-2006 /////////////////////
    vHAWB=objUpload("lstHAWB").Value
    If rMAWB="" Then
	    vHAWB=Mid(vHAWB,1,len(vHAWB)-2)
	    If IsNull(vMAWB) Or vMAWB = "0" Or vMAWB = "" Then
	        vMAWB=get_mawb_by_hawb(vHAWB)
	    End If
	End If

	vYourName=objUpload("txtYourName").Value
	vYourName=Mid(vYourName,1,len(vYourName)-2)
	vYourEmail=objUpload("txtYourEmail").Value
	vYourEmail=Mid(vYourEmail,1,len(vYourEmail)-2)
end if

Set rs=Server.CreateObject("ADODB.Recordset")
Set rs1=Server.CreateObject("ADODB.Recordset")
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

'get HAWB NUM for agent

'// Modified by Joon On Joon On Dec-8-2006 /////////////////////////////////////////////////
If checkBlank(vMAWB,"")="" And checkBlank(vHAWB,"")="" Then
Else
    If Not vHAWB="" Then
        SQL = "select a.mawb_num,a.master_agent,b.dba_name,b.business_phone,c.hawb_num " _
            & "from mawb_master a, organization b, hawb_master c " _
            & "where a.elt_account_number=b.elt_account_number and " _
            & "a.elt_account_number=c.elt_account_number and " _
            & "a.mawb_num = c.mawb_num and a.elt_account_number=" & elt_account_number _
            & " and a.master_agent=b.org_account_number and c.HAWB_NUM='" & vHAWB & "'"
    Else
	    SQL="select a.mawb_num,a.master_agent,b.dba_name,b.business_phone from mawb_master a, organization b " _
	        & "where a.elt_account_number=b.elt_account_number and a.elt_account_number = " _
	        & elt_account_number & " and a.master_agent=b.org_account_number and a.MAWB_NUM = '" & vMAWB & "'"
    End If

	rs.Open SQL, eltConn, , , adCmdText
	if Not rs.EOF then
		MasterAgentNo=rs("master_agent")
		MasterAgentName=rs("dba_name")
		MasterAgentPhone=rs("business_phone")
		vMAWB=rs("mawb_num")
	end if
	rs.close
	SQL= "select a.agent_name,a.agent_no,a.shipper_name,a.consignee_name,hawb_num,b.agent_elt_acct,b.owner_email,b.edt from hawb_master a, organization b where a.elt_account_number=b.elt_account_number and a.elt_account_number = " & elt_account_number & " and a.agent_no=b.org_account_number and a.MAWB_NUM = '" & vMAWB & "' and a.is_dome='Y' order by a.agent_name,a.hawb_num"
	rs.Open SQL, eltConn, , , adCmdText
	aIndex=0
	hIndex=0
	LastAgent=""
'////////////////////////////////////////////////////////////////////////////////////////////


'/////////////////////////
if  rs.EOF then
'/////////////////////////

		rs.close
		vHAWB=""
		response.write vAgentEmail

		vAgentName=""
		vAgentNo=""
		vAgenEmail=""

		SQL= "select a.master_agent,b.dba_name,b.owner_email,b.edt from mawb_master a, organization b where a.elt_account_number=b.elt_account_number and a.elt_account_number = " & elt_account_number & " and a.master_agent=b.org_account_number and a.MAWB_NUM = '" & vMAWB & "' "
		rs.Open SQL, eltConn, , , adCmdText
		if not rs.EOF then
			vAgentName=rs("dba_name")
			vAgentNo=rs("master_agent")
			vAgenEmail=rs("owner_email")
		end if
		rs.close

		SQL= "select invoice_no from invoice where elt_account_number = " & elt_account_number & " and air_ocean = 'A' and MAWB_NUM = '" & vMAWB & "'"
		rs.Open SQL, eltConn, , , adCmdText
		if Not rs.EOF then
			aAgentInvoice(0)=rs("invoice_no")
		end if
		if Edit="yes" then
			aAgentnvoiceCheck(0)="Y"
		else
		    if not  Mid(objUpload("cShipperInvoiceCheck" & sIndex).Value,1,1) = null then
				aAgentInvoiceCheck(0)=Mid(objUpload("cShipperInvoiceCheck" & sIndex).Value,1,1)
			end if
		end if

		rs.close
		aIndex=sIndex+1
		ahIndex=shIndex+1
		aAgentName(0) = vAgentName
		aAgentNo(0) = vAgentNo
		aAgentEmail(0) = vAgenEmail

		if send = "yes" then
				aAgentCheck(0)=Mid(objUpload("cAgentCheck" & 0).Value,1,1)
				aOnlineAlertCheck(0)=Mid(objUpload("cOnlineAlertCheck" & 0).Value,1,1)
				aAgentSubject(0)=objUpload("txtAgentSubject" & 0).Value
				aAgentSubject(0)=Mid(aAgentSubject(0),1,len(aAgentSubject(0))-2)
				aAgentEmail(0)=objUpload("txtAgentEmail" & 0).Value
				aAgentEmail(0)=Mid(aAgentEmail(0),1,len(aAgentEmail(0))-2)
				aAgentCC(0)=objUpload("txtAgentCC" & 0).Value
				aAgentCC(0)=Mid(aAgentCC(0),1,len(aAgentCC(0))-2)
				aAgentMSG(0)=objUpload("txtMSG" & 0).Value
				aAgentMSG(0)=Mid(aAgentMSG(0),1,len(aAgentMSG(0))-2)

				aInvoiceCheck(0)=Mid(objUpload("cInvoiceCheck" & 0).Value,1,1)
				aStmtCheck(0)=Mid(objUpload("cStmtCheck" & 0).Value,1,1)
				aManifestCheck(0)=Mid(objUpload("cManifestCheck" & 0).Value,1,1)
				aMAWBAgentCheck(0)=Mid(objUpload("cMAWBAgentCheck" & 0).Value,1,1)

		end if

'///////////////////////////
else
'///////////////////////////
    
	Do While Not rs.EOF
		vHAWB=rs("hawb_num")
		vShipper=rs("shipper_name")
		vConsignee=rs("consignee_name")
		vAgentName=rs("agent_name")
		vAgentNo=rs("agent_no")
		vAgentEmail=rs("owner_email")
		vAgentELTAcct=checkBlank(rs("agent_elt_acct"),0)
		'if IsNull(vAgentELTAcct) or vAgentELTAcct="" then vAgentELTAcct=0
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
			
'// Check MAWB if Master Agent // by ig 07/13/2006			
			aMAWBAgentCheck(aIndex) = "Y"
			if Not MasterAgentNo="" and not vAgentNo="" then
				if Not cLng(MasterAgentNo)=cLng(vAgentNo) then
					aAgentMSG(aIndex)="Master agent is " & MasterAgentName & chr(10) & "Phone# " & MasterAgentPhone
					aMAWBAgentCheck(aIndex) = ""
				end if
			end if

			if Edit="yes" then
				aAgentCheck(aIndex)="Y"
				if vEDTEnable="Y" then
					aOnlineAlertCheck(aIndex)="Y"
				end if
				aAgentSubject(aIndex)=vSubject
				aAgentEmail(aIndex)=vAgentEmail
			else
				aAgentCheck(aIndex)=Mid(objUpload("cAgentCheck" & aIndex).Value,1,1)
				aOnlineAlertCheck(aIndex)=Mid(objUpload("cOnlineAlertCheck" & aIndex).Value,1,1)
				aAgentSubject(aIndex)=objUpload("txtAgentSubject" & aIndex).Value
				aAgentSubject(aIndex)=Mid(aAgentSubject(aIndex),1,len(aAgentSubject(aIndex))-2)
				aAgentEmail(aIndex)=objUpload("txtAgentEmail" & aIndex).Value
				aAgentEmail(aIndex)=Mid(aAgentEmail(aIndex),1,len(aAgentEmail(aIndex))-2)
				aAgentCC(aIndex)=objUpload("txtAgentCC" & aIndex).Value
				aAgentCC(aIndex)=Mid(aAgentCC(aIndex),1,len(aAgentCC(aIndex))-2)
				aAgentMSG(aIndex)=objUpload("txtMSG" & aIndex).Value
				aAgentMSG(aIndex)=Mid(aAgentMSG(aIndex),1,len(aAgentMSG(aIndex))-2)
			end if
			LastAgent=vAgentName
'get invoice and Stmt
			SQL= "select invoice_no,amount_charged from invoice where elt_account_number = " & elt_account_number & "  and MAWB_NUM = '" & vMAWB & "' and customer_number=" & vAgentNo
			rs1.Open SQL, eltConn, , , adCmdText
			if Not rs1.EOF then
				aInvoice(aIndex)=rs1("invoice_no")
				aInvoiceAmt(aIndex)=rs1("amount_charged")
			end if
			if Edit="yes" then
				aInvoiceCheck(aIndex)="Y"
				aStmtCheck(aIndex)="Y"
			else
				aInvoiceCheck(aIndex)=Mid(objUpload("cInvoiceCheck" & aIndex).Value,1,1)
				aStmtCheck(aIndex)=Mid(objUpload("cStmtCheck" & aIndex).Value,1,1)
			end if
			rs1.close
'manifest
'			aManifest(aIndex)="MAWB=" & vMAWB & "&Agent=" & vAgentNo & "&MasterAgentNo=" & MasterAgentNo & "&AgentName=" & vAgentName & "&MasterAgentName=" & MasterAgentName & "&MasterAgentPhone=" & MasterAgentPhone
			aManifest(aIndex)="MAWB=" & vMAWB & "&Agent=" & vAgentNo & "&MasterAgentNo=" & MasterAgentNo & "&MasterAgentPhone=" & MasterAgentPhone
			if Edit="yes" then
				aManifestCheck(aIndex)="Y"

'// Check MAWB if Master Agent // Disabled by ig 07/13/2006			
'				aMAWBAgentCheck(aIndex)="Y"
			else
				aManifestCheck(aIndex)=Mid(objUpload("cManifestCheck" & aIndex).Value,1,1)
				aMAWBAgentCheck(aIndex)=Mid(objUpload("cMAWBAgentCheck" & aIndex).Value,1,1)
			end if
			aIndex=aIndex+1
			hIndex=hIndex+1
		else
			if aIndex > 0 then
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
		end if
		rs.MoveNext
	Loop
	rs.close

end if
'//////////////////////////////// by ig

'update agent file check status
	if Not Edit="yes" then
		for i=0 to aIndex-1
			SQL= "select file_checked from user_files where elt_account_number=" & elt_account_number & " and org_no=" & aAgentNo(i) 
			rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
			afIndex=0
			Do while Not rs.EOF
				vFileChecked=Mid(objUpload("cAgentFileCheck" & i & "," & afIndex).Value,1,1)
				rs("file_checked")=vFileChecked
				rs.Update
				rs.MoveNext
				afIndex=afIndex+1
			loop
			rs.Close
		next
	end if
'update shipper file check status
	if Not Edit="yes" then
		for i=0 to sIndex-1
			SQL= "select file_checked from user_files where elt_account_number=" & elt_account_number & " and org_no=" & aShipperNo(i) & " order by file_name"
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
'//  by iMoon DEC/03/2006
		dFileName=objUpload("hDeleteFileName").Value
		dFileName=Mid(dFileName,1,len(dFileName)-2)
'////////////////////////
		
		SQL= "delete from user_files where elt_account_number = " & elt_account_number & " and org_no=" & UpOrgNo & " and file_name='" & dFileName & "'"
		eltConn.Execute SQL
	end if
' get agent attached files
	for i=0 to aIndex-1
		If aAgentNo(i) = "" Then 
			aAgentNo(i) = 0 
		End if
		SQL= "select file_name,file_checked from user_files where elt_account_number=" & elt_account_number & " and org_no=" & aAgentNo(i) & " order by file_name"
		rs.Open SQL, eltConn, , , adCmdText
		afIndex=0
		Do while Not rs.EOF
			vFileName=rs("file_name")
			aAgentFileURL(i,afIndex)="/IFF_MAIN/ASP/include/viewfile.asp?OrgNo=" & aAgentNo(i) & "&FileName=" & vFileName
			aAgentFileName(i,afIndex)=vFileName
			aAgentFileCheck(i,afIndex)=rs("file_checked")
			rs.MoveNext
			afIndex=afIndex+1
		loop
		rs.Close
		aAgentFileIndex(i)=afIndex
	next
end if

Set mawb_list = Server.CreateObject("System.Collections.ArrayList")
Set fileNo_list = Server.CreateObject("System.Collections.ArrayList")

SQL= "select a.* from mawb_number a inner join hawb_master b on (a.mawb_no=b.mawb_num and a.elt_account_number=b.elt_account_number) " _
    & "where a.is_dome='Y' and a.status='B' and a.elt_account_number=" & elt_account_number & " and isnull(b.Agent_No,0)<>0 order by a.mawb_no"

rs.Open SQL, eltConn, , , adCmdText
mIndex=0
Do While Not rs.EOF

    mawb_list.Add rs("mawb_no").value
	fileNo_list.Add rs("File#").value
	
	if vMAWB = rs("mawb_no").value then
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

Set hawb_list = Server.CreateObject("System.Collections.ArrayList")
SQL = "SELECT hawb_num FROM HAWB_master WHERE elt_account_number=" & elt_account_number _
    & " and is_dome='Y' and isnull(Agent_No,0)<>0 ORDER BY hawb_num"
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

Do While Not rs.eof And Not rs.bof 
	hawb_list.Add rs("hawb_num").value
	rs.MoveNext
Loop
rs.Close

'send email to all agents
if Edit="yes" or Send="yes" or UP="yes" or RM="yes" then
	NoItem=objUpload("hNoItem").Value
	if Not NoItem="" then
		Noitem=Mid(NoItem,1,len(NoItem)-2)
	end if
end if
if NoItem="" then
	NoItem=0
end if

if Send="yes" And NoItem>0 then
	'response.buffer=True
	Set PDF = Server.CreateObject("APToolkit.Object")
	Set fso = Server.CreateObject("Scripting.FileSystemObject")
	If Not fso.FolderExists(temp_path) Then
		Set f = fso.CreateFolder(temp_path)
	End If
	If Not fso.FolderExists(temp_path & "\Eltdata") Then
		Set f = fso.CreateFolder(temp_path & "\Eltdata")
	End If
	If Not fso.FolderExists(temp_path & "\Eltdata\" & elt_account_number) Then
		Set f = fso.CreateFolder(temp_path & "\Eltdata\" & elt_account_number)
	End If
	for m=0 to NoItem-1
		'aAgentCheck(m)=Request("cAgentCheck" & m)
		AttachedFileName=""
		AttachMent=""
		vTranDT=Now

		if not aAgentNo(m)="" And Not aAgentEmail(m)="" And aAgentCheck(m)="Y" then
			AttachedFileName=temp_path & "\Eltdata\" & elt_account_number & "\agentmail" & aAgentNo(m) & ".pdf"
			r=PDF.OpenOutputFile(AttachedFileName)
' insert MAWB to pdf file
			'aMAWBAgentCheck(m)=Request("cMAWBAgentCheck" & m)
			if Not aMAWBAgentCheck(m)="" and Not vMAWB="" then
				Call InsertMAWBIntoPDF(vMAWB,"CONSIGNEE")
				Attachment="Y"
			end if
			tPieces=0
			tGrossWT=0
			tChgWT=0
			tFreight=0
' check EDT
			'aOnlineAlertCheck(m)=Request("cOnlineAlertCheck" & m)
			'aOnlineAlertCheck(m)=Mid(objUpload("cOnlineAlertCheck" & m).Value,1,1)
			if Not vMAWB="" and Not cLng(aAgentELTAcct(m))=0 and Not aOnlineAlertCheck(m)="" then
				SQL="select edt from organization where elt_account_number=" & aAgentELTAcct(m) & " and agent_elt_acct=" & elt_account_number
				rs.Open SQL, eltConn, , , adCmdText
				if Not rs.EOF then
					vEDT=rs("edt")
				end if
				rs.Close
				if vEDT="" or IsNull(vEDT)=true then
					Response.Write "<br>Your agent had disabled the EDT. Please contact your agent to enable the EDT!"
				else
' get last sec in import_mawb table
					SQL="select max(sec) As sec,processed from import_mawb where elt_account_number =" & aAgentELTAcct(m) & " and agent_elt_acct=" & elt_account_number & " and mawb_num='" & vMAWB & "' group by processed order by max(sec) desc"
					rs.Open SQL, eltConn, , , adCmdText
					if rs.EOF then
						sec=1
					else
						if IsNull(rs("sec")) then
							sec=1
						elseif rs("processed")="Y" then
							sec=rs("sec")+1
						else
							sec=rs("sec")
						end if
					end if
					rs.close
				end if
			end if

			for n=0 to aHAWBIndex(m)
'insert to import_hawb table for import agent
				if Not vMAWB="" and not aHAWB(m,n)="" and Not cLng(aAgentELTAcct(m))=0 and Not aOnlineAlertCheck(m)="" then
					SQL= "select * from hawb_master where elt_account_number = " & elt_account_number & " and hawb_num='" & aHAWB(m,n) & "'"
					rs.Open SQL, eltConn, , , adCmdText
					vShipperName=""
					vShipperInfo=""
					vConsigneeName=""
					vConsigneeInfo=""
					vNotifyName=""
					vNotifyInfo=""
					vDesc=""
					vPieces=0
					vGrossWT=0
					vChargeableWT=0
					vScale=""
					vPC=""
					if Not rs.EOF then
						vShipperName=rs("shipper_name")
						vShipperInfo=rs("shipper_info")
						vConsigneeName=rs("consignee_name")
						vConsigneeInfo=rs("consignee_info")
						vNotifyInfo=rs("account_info")
						pos=0
						pos=instr(vNotifyInfo,"NOTIFY:")
						if pos>0 then
							vNotifyInfo=Mid(vNotifyInfo,pos+7,300)
							pos=Instr(vNotifyInfo,chr(10))
							if pos>0 then
								vNotifyName=Mid(vNotifyInfo,1,pos-1)
							end if
						else
							vNotifyName=""
							vNotifyInfo=""
						end if
						vDesc=rs("desc1")
						vPieces=cLng(rs("total_pieces"))
						vGrossWT=cDbl(rs("total_gross_weight"))
						vChargeableWT=cDbl(rs("total_chargeable_weight"))
						vScale=rs("weight_scale")
						vPC=rs("coll_1")
						vFreight=cDbl(rs("collect_total"))
						tPieces=tPieces+vPieces
						tGrossWT=tGrossWT+vGrossWT
						tChgWT=tChgWT+vChargeableWT
					end if
					rs.Close
					if vEDT="Y" then
						SQL= "select * from import_hawb where elt_account_number =" & aAgentELTAcct(m) & " and agent_elt_acct=" & elt_account_number & " and hawb_num='" & aHAWB(m,n) & "' and sec=" & sec
						rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
						If rs.EOF=true Then
							rs.AddNew
							rs("elt_account_number")=aAgentELTAcct(m)
						    rs("agent_elt_acct")=elt_account_number
							rs("iType")="A"
							rs("hawb_num")=aHAWB(m,n)
							rs("sec")=sec
						end if
						rs("tran_dt")=vTranDT
						rs("mawb_num")=vMAWB
						rs("processed")="N"
						rs("shipper_name")=vShipperName
						rs("shipper_info")=vShipperInfo
						rs("consignee_name")=vConsigneeName
						rs("consignee_info")=vConsigneeInfo
						rs("notify_name")=vNotifyName
						rs("notify_info")=vNotifyInfo
						'rs("goods_desc")=vDesc
						rs("pieces")=vPieces
						rs("uom")=vUOM
						rs("gross_wt")=vGrossWT
						rs("chg_wt")=vChargeableWT
						'rs("kg_lb")=vScale
						rs("prepaid_collect")=vPC
						'rs("freight")=vFreight
						rs.update
						rs.close
					end if
				end if
' insert hawb to pdf file
				if aHAWBCheck(m,n)="Y" then
					HAWBtmp=aHAWB(m,n)
					Call InsertHAWBIntoPDF(HAWBtmp,"CONSIGNEE")
					Attachment="Y"
				end if
			next
' insert to import_mawb table for import agent

			if Not vMAWB="" and Not cLng(aAgentELTAcct(m))=0 and Not aOnlineAlertCheck(m)="" and vEDT="Y" then
				SQL= "select * from import_mawb where elt_account_number =" & aAgentELTAcct(m) & " and agent_elt_acct=" & elt_account_number & " and MAWB_NUM='" & vMAWB & "' and sec=" & sec
				rs.Open SQL, eltConn, adOpenDynamic, adLockPessimistic, adCmdText
				If rs.EOF=true Then
					rs.AddNew
					rs("elt_account_number")=aAgentELTAcct(m)
					rs("agent_elt_acct")=elt_account_number
					rs("iType")="A"
					rs("mawb_num")=vMAWB
					rs("sec")=sec
				end if
				rs("processed")="N"
				rs("export_agent_name")=vFF
				rs("tran_dt")=vTranDT
				rs("carrier")=vCarrier
				rs("file_no")=vFileNo
				rs("flt_no")=vFLT
				rs("etd")=vETD
				rs("eta")=vETA
				rs("dep_port")=vDepPort
				rs("arr_port")=vArrPort
				rs("pieces")=tPieces
				rs("gross_wt")=tGrossWT
				rs("chg_wt")=tChgWT
				rs("agent_debit_no")=aInvoice(m)
				if aInvoiceAmt(m)="" then aInvoiceAmt(m)=0
				rs("agent_debit_amt")=aInvoiceAmt(m)
				rs.update
				rs.close
			end if
' insert agent stmt to pdf file

' insert invoice to pdf file
			'aInvoiceCheck(m)=Request("cInvoiceCheck" & m)
			if Not aInvoiceCheck(m)="" and Not vMAWB="" then
				Call InsertInvoiceIntoPDF(aInvoice(m))
				Attachment="Y"
			end if
'insert agent stmt to pdf file
			if Not aStmtCheck(m)="" and Not aInvoice(m)="" then
				Call InsertSTMTIntoPDF(vMAWB,aAgentNo(m))
				Attachment="Y"
			end if
' insert manifest to pdf file
			'aManifestCheck(m)=Request("cManifestCheck" & m)
			if Not aManifestCheck(m)="" then
				Call InsertManifestIntoPDF(vMAWB,aAgentName(m),aAgentNo(m),MasterAgentNo,MAsterAgentName,MasterAgentPhone)
				Attachment="Y"
			end if
			PDF.CloseOutputFile
			Set Mail=Server.CreateObject("Persits.MailSender")
			MailServer=Request.ServerVariables("SERVER_NAME")
			Mail.Host = MailHost
            Mail.From=vYourEmail
			Mail.Subject=aAgentSubject(m)
			If Trim(vYourName) = "" Then
				Mail.FromName=vYourEmail	
			else
				Mail.FromName=vYourName
			End If
			Mail.AddAddress aAgentEmail(m)
			if Not aAgentCC(m)="" then
				Mail.AddCC aAgentCC(m)
			end if
			if Not AttachedFileName="" And Attachment="Y" then
				Mail.AddAttachment AttachedFileName
				for n=0 to aAgentFileIndex(m)-1
					'aAgentFileCheck(m,n)=Mid(objUpload("cAgentFileCheck" & m & "," & n).Value,1,1)
					vDest=temp_path & "\Eltdata\" & elt_account_number & "\" & aAgentNo(m)
					if aAgentFileCheck(m,n)="Y" then
						Call SaveBinaryFile(aAgentNo(m),aAgentFileName(m,n))
						Mail.AddAttachment vDest & "\" & aAgentFileName(m,n)
					end if
				next
			end if
			'Mail.Body=aAgentMSG(m)
			str="<HTML><style type='text/css'><!--body      { margin:10px; }td.title  { font-family:verdana; font-size:12px; color:black; background-color:#FFFFFF; }td.titleb { font-family:verdana; font-size:12px; font-weight:bold; color:black; background-color:#FFFFFF; }td.head   { font-family:verdana; font-size:11px; font-weight:bold; color:black; background-color:#D0D0D0; }td.foot   { font-family:verdana; font-size:11px; color:black; background-color:#D0D0D0; }td.data   { font-family:verdana; font-size:11px; color:black; background-color:#F0F0F0; }td.datab  { font-family:verdana; font-size:11px; font-weight:bold; color:black; background-color:#F0F0F0; }td.text   { font-family:verdana; font-size:11px; color:black; background-color:#FFFFFF; }a:link    { color:black; }a:visited { color:black; }a:hover   { color:gray; }//--></style>"
			str=str & "<BODY BGCOLOR=#FFFFFF>" & aAgentMSG(m) & "</BODY></html>"
			Mail.Body=str
			Mail.IsHTML=True
			On Error Resume Next
			Mail.Send	' send message
			error_num=Err.Number
			if error_num>0 then
				Response.Write("<br>Send Mail to Agent " & aAgentName(m) & " Failed with Error # " & CStr(Err.Number) & " " & Err.Description)
				Err.Clear
			else
			%>
				<script language='javascript'>//alert("Send Mail to Agent "+"'<%=aAgentName(m)%>'");</script>
			<%
				Response.Write "<br>Send Mail to Agent " & aAgentName(m) & " Success!"
			end if
			Set Mail=Nothing
		end if
	next
	set PDF=nothing
	'response.end
end if
%>

<%
  Set rs  = Nothing
  Set rs1 = Nothing
%>

<!--  #include file="../include/recent_file.asp" -->
<%
	rEdit=Request.QueryString("rEdit")
	if rEdit = "yes" then
		vMAWB = Request.QueryString("rMAWB")
	end if

	 if rEdit="yes" then
			response.write("<body link='336699' vlink='336699' leftmargin='0' topmargin='0' marginwidth='0' marginheight='0' onload='MAWBCHANGE()'>")
			rEdit=""
		else
			response.write("<body link='336699' vlink='336699' leftmargin='0' topmargin='0' marginwidth='0' marginheight='0'>")
	 end if
%>

<%
'// Input greeting message by ig 7/13/2006 
%>
<!--  #INCLUDE FILE="../include/FunctionMailExtra.asp" -->
<%
IF Edit = "yes" or rEdit = "yes" then
	DIM tmpGreetingMessage
	tmpGreetingMessage = GET_GREETING_MESSAGE( "AE/Agent Pre-Alert" )
	 for i=0 to aIndex-1
		aAgentMSG(i) = tmpGreetingMessage & chr(10)	& aAgentMSG(i)						
	 next
End if

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

'// Added by Joon on Dec-8-2006 ////////////////////////////////////////////////////////////////

Function get_mawb_by_hawb(arg)

    Dim resV,SQL,rs
    
    Set rs=Server.CreateObject("ADODB.Recordset")
    
    resV = ""
    SQL = "select a.MAWB_NUM from mawb_master a, hawb_master b where " _
        & "a.elt_account_number = b.elt_account_number and " _
        & "a.MAWB_NUM = b.mawb_num and b.HAWB_NUM='" & arg & "' and " _
        & "a.elt_account_number=" & elt_account_number & " group by a.MAWB_NUM"
    rs.Open SQL, eltConn, , , adCmdText
    
    If Not rs.EOF And Not rs.BOF Then
        resV = rs("MAWB_NUM")
    End If
    rs.Close
    
    get_mawb_by_hawb = resV
End Function

'///////////////////////////////////////////////////////////////////////////////////////////////

%>
<body>
<!-- tooltip placeholder -->
<div id="tooltipcontent"></div>
<!-- placeholder ends -->
<form name=form1 enctype="multipart/form-data">
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr>
    <td width="53%" height="32" align="left" valign="middle" class="pageheader">Pre-Alert</td>
    <td width="47%" align="right" valign="middle"><span class="bodyheader style1">FILE NO.</span><input name="txtJobNum" type=text class="lookup" size="22" value="Search Here" onFocus="javascript: this.value=''; this.style.color='#000000'; " onKeyPress="javascript: if(event.keyCode == 13) { lookupFile(); }"><img src="../images/icon_search.gif" name="B1" width="33" height="27" align="absmiddle"  style="cursor:hand" onClick="lookupFile()" ></td>
  </tr>
</table>
<div class="selectarea">
    <table width="95%" border="0" align="center" cellpadding="0" cellspacing="0">
        
        <tr>
            <td width="62%" valign="bottom"><table border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="147"><span class="select">Select Master Airbill No. or </span></td>
                    <td width="1"></td>
                    <td width="128"><span class="select">House AWB No. </span></td>
                </tr>
                <tr>
                    <td><!-- //Start of Combobox// -->
<%  iMoonDefaultValue = vMAWB %>
<%  iMoonComboBoxName =  "lstMAWB" %>
<%  iMoonComboBoxWidth =  "140px" %>
<script language="javascript"> function <%=iMoonComboBoxName%>_OnChangePlus() {	MAWBChange(); } </script>
<div id="<%=iMoonComboBoxName%>_Container" class="ComboBox" style="width:<%=iMoonComboBoxWidth%>;POSITION:;TOP:;LEFT:;Z-INDEX:;"><input name="<%=iMoonComboBoxName%>:Text" type="text" id="<%=iMoonComboBoxName%>_Text" class="ComboBox" autocomplete="off" style="width:<%=iMoonComboBoxWidth%>;vertical-align:middle" value="<%=iMoonDefaultValue%>"/><div id="<%=iMoonComboBoxName%>_Div" style="display:none;position:absolute;top:0;left:0;width:17px"><img id="<%=iMoonComboBoxName%>_Button" src="/ig_common/Images/combobox_drop.gif" border="0" /></div></div><div id="<%=iMoonComboBoxName%>_NewDiv" style="display:none;position:absolute;top:0;left:0;width:17px"><img id="<%=iMoonComboBoxName%>_AddNewButton" src="/ig_common/Images/combobox_addnew.gif" border="0" /></div>
<!-- /End of Combobox/ --><select name="lstMAWB" id="lstMAWB" listsize = "20" class="ComboBox" style="width: 140px;display:none" onChange="ComboBox_SimpleAttach(this, this.form['<%=iMoonComboBoxName%>_Text'])">
                      <option value=0>Select One</option>
                      <% for i=0 to mawb_list.count-1 %>
                      <option <% if vMAWB=mawb_list(i) then response.write("selected") %>><%= mawb_list(i) %></option>
                      <% next %>
                    </select>
<!-- /End of Combobox/ --></td>
                    <td></td>
                    <td><!-- //Start of Combobox// -->	
<%  iMoonDefaultValue = "" %>						
<%  iMoonComboBoxName =  "lstHAWB" %>
<%  iMoonComboBoxWidth =  "140px" %>
<script language="javascript"> function <%=iMoonComboBoxName%>_OnChangePlus() {	HAWBChange(); } </script>
<div id="<%=iMoonComboBoxName%>_Container" class="ComboBox" style="width:<%=iMoonComboBoxWidth%>;POSITION:;TOP:;LEFT:;Z-INDEX:;">
    <input name="<%=iMoonComboBoxName%>:Text" type="text" id="<%=iMoonComboBoxName%>_Text" class="ComboBox" autocomplete="off" style="width:<%=iMoonComboBoxWidth%>;vertical-align:middle" value="<%=iMoonDefaultValue%>"/><div id="<%=iMoonComboBoxName%>_Div" style="display:none;position:absolute;top:0;left:0;width:17px"><img id="<%=iMoonComboBoxName%>_Button" src="/ig_common/Images/combobox_drop.gif" border="0" /></div></div><div id="<%=iMoonComboBoxName%>_NewDiv" style="display:none;position:absolute;top:0;left:0;width:17px"><img id="<%=iMoonComboBoxName%>_AddNewButton" src="/ig_common/Images/combobox_addnew.gif" border="0" /></div>
<!-- /End of Combobox/ --><select name="lstHAWB" id="lstHAWB" listsize = "20" class="ComboBox" style="width: 140px;display:none" onChange="ComboBox_SimpleAttach(this, this.form['<%=iMoonComboBoxName%>_Text'])">
                      <option value=0>Select One</option>
                      <% for i=0 to hawb_list.count-1 %>
                      <option <% if vHAWB=hawb_list(i) then response.write("selected") %>><%= hawb_list(i) %></option>
                      <% next %>
                    </select>
<!-- /End of Combobox/ --></td>
                </tr>
            </table></td>
            <td width="38%" align="right" valign="bottom">&nbsp;</td>
        </tr>
    </table>
</div>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="997132" bgcolor="997132" class="border1px">

  <tr>
    <td height="100%">
      
			<input type=hidden name="hNoItem" value="<%= aIndex %>">
			<input type=hidden name="hShipperNoItem" value="<%= sIndex %>">
			<input type=hidden name="hExportAgent" value="<%= vFF %>">
			<input type=hidden name="hDeleteFileName">			
        <table width="100%" border="0" cellpadding="2" cellspacing="0">
          <tr bgcolor="edd3cf">
            <td height="24" colspan="6" align="center" valign="middle" bgcolor="eec983" class="bodyheader"><span class="pageheader"><img src="../images/button_send_email.gif" width="101" height="18" name="bSend" onClick="SendClick()"  style="cursor:hand"></span></td>
          </tr>
          <tr bgcolor="997132">
            <td colspan="6" height="1" align="left" valign="top" class="bodyheader"></td>
          </tr>
          <tr align="center" valign="middle" bgcolor="f3d9a8">
            <td height="24" colspan="6" align="center" bgcolor="#f3f3f3" class="bodyheader"><br>
                    <table width="65%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td width="50%" align="left" valign="middle"><span class="goto"><img src="/iff_main/ASP/Images/icon_email_history.gif" align="absbottom"><a href="javascript:;" onClick="ShowEmailHistory()">View Email History</a></span></td>
                            <td width="50%" height="28" align="right" class="bodyheader"><img src="/iff_main/ASP/Images/required.gif" align="absbottom">Required field</td>
                        </tr>
                    </table>
              <table width="65%" border="0" cellpadding="2" cellspacing="0" bordercolor="997132" bgcolor="edd3cf" class="border1px">
                
<!-- modified by Joon on Dec-8-2006 --->                
                
<!-- End of modified by Joon on Dec-8-2006 --->                                        
                <tr align="left" valign="middle" bgcolor="#f3d9a8">
                  <td width="1" align="left" valign="middle" class="bodycopy">&nbsp;</td>
                  <td width="222" height="20" align="left" valign="middle" bgcolor="#f3d9a8" class="bodyheader">Your Name</td>
                  <td width="408" align="left" valign="middle" class="bodycopy">                    </td>
                  <td width="408" align="left" valign="middle" class="bodycopy"></td>
                </tr>
                <tr align="left" valign="middle" bgcolor="#F3f3f3">
                    <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">&nbsp;</td>
                    <td colspan="3" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy"><input name="txtYourName" class="shorttextfield" value="<%= vYourName %>" size="28"><!-- for File No. Search -->					
					<select name="lstFileNo" size="1" class="smallselect" style="width: 10px; visibility:hidden" >
                      <option value=0></option>
                      <% for i=0 to mIndex-1 %>
                      <option><%= fileNo_list(i) %></option>
                      <% next %>
                  </select></td>
                    </tr>
                <tr align="left" valign="middle" bgcolor="#f3d9a8">
                    <td height="20" align="left" valign="middle" class="bodycopy">&nbsp;</td>
                    <td height="20" align="left" valign="middle" class="bodyheader">From</td>
                    <td height="20" align="left" valign="middle" class="bodycopy">&nbsp;</td>
                    <td align="left" valign="middle" class="bodycopy">&nbsp;</td>
                </tr>
                <tr align="left" valign="middle" bgcolor="#F3f3f3">
                  <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">&nbsp;</td>
                  <td colspan="3" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy"><input name="txtYourEmail" type="text" class="shorttextfield" value="<%= vYourEmail %>" size="45"></td>
                  </tr>
              </table>
              <br></td>
        </table>
	    <table width="100%" border="0" cellpadding="2" cellspacing="0" bordercolor="997132" class="bodycopy">
          <input type=hidden id="AgentCheck">
          <input type=hidden id="hHAWBIndex">
          <input type=hidden id="InvoiceCheck">
          <input type=hidden id="STMTCheck">
          <input type=hidden id="ManifestCheck">
          <input type=hidden id="MAWBAgentCheck">
          <input type=hidden id="hAgentFileIndex">
          <input type=hidden id="OnlineAlertCheck">
          <% for i=0 to aIndex-1 %>
          <% If checkBlank(aAgentNo(i),0)<>0 Then %>
          <tr>
            <td colspan="6" height="2" align="left" valign="middle" bgcolor="997132" class="bodycopy"></td>
          </tr>
          
          <tr>
            <td width="42" align="center" valign="middle" bgcolor="#FFFFFF" class="bodyheader">
              <input type="checkbox" id="AgentCheck" name="cAgentCheck<%= i %>" value="Y" <% if aAgentCheck(i)="Y" then response.write("checked") %> onClick="AgentCheckClick(<%= i %>)">            </td>
            <td width="78" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">Agent</td>
            <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF"> <input name="hAgentNo<%= i %>" type=hidden value="<%= aAgentNo(i) %>">
              <input name="txtAgentName<%= i %>" type="text" class="shorttextfield" value="<%= aAgentName(i) %>" size="58">            </td>
            <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF"><input type=checkbox id="OnlineAlertCheck" name="cOnlineAlertCheck<%= i %>" value="Y" <% if aOnlineAlertCheck(i)="Y" then response.write("checked") %>>
                Online
              Alert 
              <% if aAgentELTAcct(i)<>0 and checkBlank(aAgentELTAcct(i),"") <> "" then response.write( aAgentELTAcct(i) ) end if%>
              <% if mode_begin then %>
              <div style="width:21px; display:inline; vertical-align:text-bottom" onMouseOver="showtip(' If the recipient on this line is also a FreightEasy member, this pre-alert may be sent directly to their FreightEasy account.')";
onMouseOut="hidetip()"><img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
              <% end if %></td>
          </tr>
          <tr>
              <td align="left" valign="middle" bgcolor="#F3f3f3" class="bodycopy">&nbsp;</td>
              <td align="left" valign="middle" bgcolor="#F3f3f3" class="bodyheader"><img src="/iff_main/ASP/Images/required.gif" align="absbottom">TO</td>
              <td colspan="4" align="left" valign="middle" bgcolor="#F3f3f3" class="bodycopy"><input name="txtAgentEmail<%= i %>" type="text" class="shorttextfield" value="<%= aAgentEmail(i) %>" size="58"></td>
          </tr>
          
          <tr>
            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">&nbsp;</td>
            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">CC</td>
            <td colspan="4" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy"><input name="txtAgentCC<%= i %>" type="text" class="shorttextfield" value="<%= aAgentCC(i) %>" size="58"></td>
          </tr>
          <tr>
            <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">&nbsp;</td>
            <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy"><span class="bodyheader">Subject</span></td>
            <td colspan="4" align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy"><input name="txtAgentSubject<%= i %>" type="text" class="shorttextfield" value="<%= aAgentSubject(i) %>" size="80"></td>
          </tr>
          <tr>
            <td height="22" align="left" valign="middle" bgcolor="#f3f3f3"  class="bodycopy">&nbsp;</td>
            <td align="left" valign="middle" bgcolor="#f3f3f3"  class="bodycopy">&nbsp;</td>
            <td align="left" valign="middle" bgcolor="#f3f3f3"  class="bodycopy" width="190">
              <p><font color="#000066"><em>
                <input type=checkbox id="MAWBAgentCheck" name="cMAWBAgentCheck<%= i %>" value="Y" <% if aMAWBAgentCheck(i)="Y" then response.write("checked") %>>
                <font color="#CC3300">MAWB:</font><a href= "javascript:void(viewPop('mawb_pdf.asp?MAWB=<%= vMAWB %>&Copy=CONSIGNEE'));"><%= vMAWB %></a></em></font></p></td>
            <td align="left" valign="middle" bgcolor="#f3f3f3"  class="bodycopy" width="194">
              <p><font color="#000066"><em><%if  Not aManifest(i) = "" then %>
                <input type=checkbox id="ManifestCheck" name="cManifestCheck<%= i %>" value="Y" <% if aManifestCheck(i)="Y" then response.write("checked") %>>
                <font color="#CC3300">Manifest:</font><a href= "javascript:void(viewPop('manifest_pdf.asp?<%= aManifest(i) %>'));"><%= vMAWB %></a><%End if%></em></font></p></td>
            <td align="left" valign="middle" bgcolor="#f3f3f3"  class="bodycopy" width="181">
              <p><font color="#000066"><em><%if  Not aInvoice(i) = "" then %>
                <input type=checkbox id="InvoiceCheck" name="cInvoiceCheck<%= i %>" value="Y" <% if aInvoiceCheck(i)="Y" then response.write("checked") %>>
                <font color="#CC3300">Invoice:</font><a href= "javascript:void(viewPop('../acct_tasks/invoice_pdf.asp?InvoiceNo=<%= aInvoice(i) %>'));"><%= aInvoice(i) %></a><%End if%></em></font></p></td>
            <td align="left" valign="middle" bgcolor="#f3f3f3"  class="bodycopy" width="443">
              <p><font color="#000066"><em><%if  Not aInvoice(i) = "" then %>
                <input type=checkbox id="StmtCheck" name="cStmtCheck<%= i %>" value="Y" <% if aStmtCheck(i)="Y" then response.write("checked") %>>
                <font color="#CC3300">Statement:</font><a href= "javascript:void(viewPop('../acct_tasks/agent_stmt.asp?MAWB=<%= vMAWB %>&AgentNo=<%= aAgentNo(i) %>'));"><%= aInvoice(i) %></a><%End if%></em></font></p></td>
          </tr>
          <input type=hidden id="hHAWBIndex" name="hHawbIndex<%= i %>" value="<%= aHAWBIndex(i) %>">
          <input type=hidden id="HAWBCheck<%= i %>">
          <% for j=0 to aHAWBIndex(i) step 4%>
          <tr>
            <td height="22" align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">&nbsp;</td>
            <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">&nbsp;            </td>
            <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
              <p><font color="#000066"><em>
			  <% if aHAWB(i,j) = "" then%>
			  <%else%>
                <input type=checkbox id="HAWBCheck<%= i %>" name="cHAWBCheck<%= i %>,<%= j %>" value="Y" <% if aHAWBCheck(i,j)="Y" then response.write("checked") %>>
                <font color="#CC3300">HAWB:</font><a href= "javascript:void(viewPop('hawb_pdf.asp?HAWB=<%= aHAWB(i,j) %>&Copy=CONSIGNEE'));"><%= aHAWB(i,j) %></a>
			  <% end if%>
                </em></font><font color="#000066"></p></td>
            <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
              <p><font color="#000066"><em>
                <% if aHAWB(i,j+1) = "" then%><%else%>
                <input type=checkbox id="HAWBCheck<%= i %>" name="cHAWBCheck<%= i %>,<%= j+1 %>" value="Y" <% if aHAWBCheck(i,j+1)="Y" then response.write("checked") %>><a href= "javascript:void(viewPop('hawb_pdf.asp?HAWB=<%= aHAWB(i,j+1) %>&Copy=CONSIGNEE'));"><%= aHAWB(i,j+1) %></a>
                <%end if%>
                </em></font></p></td>
            <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
              <p><font color="#000066">
                <% if aHAWB(i,j+2) = "" then%>
                <%else%>
                <em>
                <input type=checkbox id="HAWBCheck<%= i %>" name="cHAWBCheck<%= i %>,<%= j+2 %>" value="Y" <% if aHAWBCheck(i,j+2)="Y" then response.write("checked") %>><a href= "javascript:void(viewPop('hawb_pdf.asp?HAWB=<%= aHAWB(i,j+1) %>&Copy=CONSIGNEE'));"><%= aHAWB(i,j+2) %></a>
                <%end if%>
                </em></font></p></td>
            <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">
              <p><font color="#000066"><em>
                <% if aHAWB(i,j+3) = "" then%><%else%>
                <input type=checkbox id="HAWBCheck<%= i %>" name="cHAWBCheck<%= i %>,<%= j+3 %>" value="Y" <% if aHAWBCheck(i,j+3)="Y" then response.write("checked") %>><a href= "javascript:void(viewPop('hawb_pdf.asp?HAWB=<%= aHAWB(i,j+3) %>&Copy=CONSIGNEE'));"><%= aHAWB(i,j+3) %></a>
                <%end if%>
                </em></font></p></td>
          </tr>
          <% next %>
          <tr bgcolor="#F3f3f3">
            <td height="20" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">&nbsp;</td>
            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">Attach
              Files</td>
            <td colspan="4" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">
              <input name="File<%= aAgentNo(i) %>" type="File" size=50 onKeyDown="return false" />
              &nbsp;&nbsp;&nbsp; <img src="../images/button_upload.gif" width="95" height="18" name="txtUpload" onClick="UpLoadClick(<%= aAgentNo(i) %>)"  style="cursor:hand">
              <% if mode_begin then %>
              <div style="width:21px; display:inline; vertical-align:text-bottom" onMouseOver="showtip('Click Browse to find the fine on your local computer, and click Attach Files to add it to the email.  This is useful for documents such as packing lists and commercial invoices.')";
onMouseOut="hidetip()"><img src="../Images/button_info.gif" align="bottom" class="bodylistheader"></div>
              <% end if %></td>
          </tr>
          <input type=hidden id="AgentFileCheck<%= i %>">
          <input type=hidden id="hAgentFileIndex" name="hAgentFileIndex<%= i %>" value="<%= aAgentFileIndex(i) %>">
          <% for j=0 to aAgentFileIndex(i)-1 step 4%>
          <tr bgcolor="#FFFFFF">
            <td height="20" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">&nbsp;</td>
            <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">&nbsp;</td>
            <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy"><em>
                    <input type=checkbox id="AgentFileCheck<%= i %>" name="cAgentFileCheck<%= i %>,<%= j %>" value="Y" <% if aAgentFileCheck(i,j)="Y" then response.write("checked") %>><font color="#CC3300">Attachment 1:</font><a href= "javascript:void(viewPop('<%= aAgentFileURL(i,j) %>'));"><%= aAgentFileName(i,j) %></a><img src="../Images/spacer.gif" width="10" height="8"><img src="../images/button_delete.gif" align="absbottom" onClick="DeleteFile(<%= aAgentNo(i) %>,'<%= aAgentFileName(i,j) %>')"  style="cursor:hand"></em></td>
            <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy"><em>
                <% if aAgentFileName(i,j+1) = "" then%>
                <%else%>
                <input type=checkbox id="AgentFileCheck<%= i %>" name="cAgentFileCheck<%= i %>,<%= j+1 %>" value="Y" <% if aAgentFileCheck(i,j+1)="Y" then response.write("checked") %>><font color="#CC3300">Attachment 2:</font>
                <a href= "javascript:void(viewPop('<%= aAgentFileURL(i,j+1) %>'));"><%= aAgentFileName(i,j+1) %></a><img src="../Images/spacer.gif" width="10" height="8"><img src="../images/button_delete.gif" align="absbottom" onClick="DeleteFile(<%= aAgentNo(i) %>,'<%= aAgentFileName(i,j+1) %>')"  style="cursor:hand">
                <%end if%>
            </em></td>
            </tr>
          <tr bgcolor="#FFFFFF">
              <td height="20" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">&nbsp;</td>
              <td align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy">&nbsp;</td>
              <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy"><em>
                  <% if aAgentFileName(i,j+2) = "" then%>
                  <%else%>
                  <input type=checkbox id="AgentFileCheck<%= i %>" name="cAgentFileCheck<%= i %>,<%= j+2%>" value="Y" <% if aAgentFileCheck(i,j+2)="Y" then response.write("checked") %>><font color="#CC3300">Attachment 3:</font>
                  <a href= "javascript:void(viewPop('<%= aAgentFileURL(i,j+2) %>'));"><%= aAgentFileName(i,j+2) %></a><img src="../Images/spacer.gif" width="10" height="8"><img src="../images/button_delete.gif" align="absbottom" onClick="DeleteFile(<%= aAgentNo(i) %>,'<%= aAgentFileName(i,j+2) %>')"  style="cursor:hand">
                  <%end if%>
              </em></td>
              <td colspan="2" align="left" valign="middle" bgcolor="#FFFFFF" class="bodycopy"><em>
                  <% if aAgentFileName(i,j+3) = "" then%>
                  <%else%>
                  <input type=checkbox id="AgentFileCheck<%= i %>" name="cAgentFileCheck<%= i %>,<%= j+3 %>" value="Y" <% if aAgentFileCheck(i,j+3)="Y" then response.write("checked") %>><font color="#CC3300">Attachment 4:</font>
                  <a href= "javascript:void(viewPop('<%= aAgentFileURL(i,j+3) %>'));"><%= aAgentFileName(i,j+3) %></a><img src="../Images/spacer.gif" width="10" height="8"><img src="../images/button_delete.gif" align="absbottom" onClick="DeleteFile(<%= aAgentNo(i) %>,'<%= aAgentFileName(i,j+3) %>')"  style="cursor:hand">
                  <%end if%>
              </em></td>
              </tr>
          <% next %>
          <tr bgcolor="ffffff">
            <td height="20" align="left" valign="middle" bgcolor="#f3f3f3" class="bodycopy">&nbsp;</td>
            <td colspan="5" align="left" valign="top" bgcolor="#f3f3f3" class="bodyheader">Message
                <br>
                <textarea name="txtMSG<%= i %>" cols="100" rows="3" class="multilinetextfield"><%= aAgentMSG(i) %></textarea></td>
            </tr>
          <% End If %>
          <% next %>
        </table>
		<table width="100%" border="0" cellpadding="2" cellspacing="0">
          <tr>
            <td height="1" colspan="6" align="left" valign="middle" bgcolor="997132" class="bodycopy"></td>
          </tr>
		  <tr>
            <td height="22" align="center" valign="middle" bgcolor="eec983"><img src="../images/button_send_email.gif" width="101" height="18" name="bSend" onClick="SendClick()"  style="cursor:hand"></td>
         </tr>
        </table>
      
    </td>
  </tr>
</table></form>
</body>

<script language=VBscript>

// Add search function 7/11/2006

/////////////////////////////
Sub Lookup()
/////////////////////////////
DIM mIndex,existMAWB,MAWB
 mIndex = "<%=mIndex%>"
	MAWB=UCase(document.form1.txtSMAWB.value)

	if NOT TRIM(MAWB) = "" then
		existMAWB = false
		For i=0 to mIndex
			if MAWB = UCase(document.form1.lstMAWB.item(i).text) then
				existMAWB = true
				exit for
			end if
		Next	
		
		if existMAWB then
				document.form1.lstMAWB.selectedIndex = i
				document.form1.action="pre_alert.asp?Edit=yes&rMAWB="& document.form1.txtSMAWB.value & "&WindowName=" & window.name
				document.form1.txtsMAWB.value = ""
				document.form1.method="POST"
				document.form1.target = "_self"
				form1.submit()
		else
				msgbox "MAWB # " & MAWB & " does not exist."
		end if		
	END IF
End Sub

/////////////////////////////
Sub LookupFile()
/////////////////////////////
DIM mIndex, existMJob, JobNo, mFile,sIndex,MAWB

mIndex = "<%=mIndex%>"
	JobNo=UCase(document.form1.txtJobNum.value)
    fileno=document.form1.txtJobNum.value
	if NOT TRIM(JobNo) = "" and NOT fileno = "Search Here" then
		existMJob = false
		For i=0 to mIndex
			if Trim(Replace(JobNo,"-","")) = Trim(Replace(UCase(document.form1.lstFileNo.item(i).text),"-","")) then
				existMJob = true
				MAWB = document.form1.lstMAWB.item(i).text
				exit for
			end if
		Next	
	
		if existMJob then
				document.form1.txtJobNum.value = ""
				document.form1.lstMAWB.selectedIndex = i
				document.form1.action="pre_alert.asp?Edit=yes&rMAWB="& MAWB & "&WindowName=" & window.name
				document.form1.method="POST"
				document.form1.target = "_self"
				form1.submit()
		else
				msgbox "File # " & JobNo & " does not exist."
		end if
	else
	    msgbox "Please enter a File No!"		
	end if	
End Sub

///////////////////////////////////// by ig
Sub SendClick()

if document.form1.txtYourEmail.value = "" then
	msgbox "Please enter your email address!"
	exit sub
end if

if document.form1.txtYourName.value = "" then
	msgbox "Please enter your name!"
	exit sub
end if

tmpIndex =  "<%= aIndex %>"
if not tmpIndex = "" then 
Mail_Due = 0
For iii = 0 To tmpIndex-1
	If document.all("AgentCheck").item(iii+1).checked=True Then
		'// Modifed by Joon on Feb/07/2007 /////////////////////
		If document.all("txtAgentEmail" & iii).value = "" Then
	        MsgBox "Please, enter recipient's email address."
	        Exit Sub
	    Else
		    Mail_Due = Mail_Due + 1
		End If
	End if
Next

if Mail_Due = 0 Then
	MsgBox "Please check at least one item."
	Exit sub
End If

ParamH = Mail_Due * 20 + 120

jPopUp(ParamH)


document.form1.action="pre_alertOK.asp?Send=yes"
document.form1.method="post"
document.form1.target="popUpWindow"
form1.submit()

else

msgbox "Please Select AirBill or File No!"

end if
End Sub

Sub MAWBChange()
    '// If document.form1.lstMAWB.selectedindex > 0 then
    document.form1.action="pre_alert.asp?Edit=yes&rMAWB="& (document.form1.lstMAWB.item(document.form1.lstMAWB.selectedindex).Text)
    document.form1.method="post"
    document.form1.target="_self"
    form1.submit()
    '// End if
End Sub

/// added by Joon on Dec-08-2006 /////////////////////////////////////

Sub HAWBChange()
    '// If document.form1.lstHAWB.selectedindex > 0 then
    document.form1.lstMAWB.value = ""
    document.form1.action="pre_alert.asp?Edit=yes"
    document.form1.method="post"
    document.form1.target="_self"
    form1.submit()
    '// End if
End Sub

///////////////////////////////////////////////////////////////////////

Sub AgentCheckClick(m)

if  document.all("hHAWBIndex").item(m+1).Value = ""  then
	NoItem = 1
else
	NoItem=document.all("hHAWBIndex").item(m+1).Value
end if

NoFile=document.all("hAgentFileIndex").item(m+1).Value

if document.all("AgentCheck").item(m+1).checked=True then

On Error Resume Next
	document.all("MAWBAgentCheck").item(m+1).checked=True
On Error Resume Next
	document.all("InvoiceCheck").item(m+1).checked=True
On Error Resume Next
	document.all("StmtCheck").item(m+1).checked=True
On Error Resume Next
	document.all("ManifestCheck").item(m+1).checked=True
On Error Resume Next
	document.all("OnlineAlertCheck").item(m+1).checked=True


	for i=0 to NoItem
		if  not document.all("hHAWBIndex").item(m+1).Value = ""  then
			document.all("HAWBCheck" & m).item(i+1).checked=True
		end if
	next
	
	for i=0 to NoFile-1
		On Error Resume Next
		document.all("AgentFileCheck" & m).item(i+1).checked=True
	next
Else

On Error Resume Next
	document.all("MAWBAgentCheck").item(m+1).checked=False
On Error Resume Next
	document.all("MAWBAgentCheck").item(m+1).checked=False
On Error Resume Next
	document.all("InvoiceCheck").item(m+1).checked=False
On Error Resume Next
	document.all("StmtCheck").item(m+1).checked=False
On Error Resume Next
	document.all("ManifestCheck").item(m+1).checked=False
On Error Resume Next
	document.all("OnlineAlertCheck").item(m+1).checked=False

	for i=0 to NoItem
		if  not document.all("hHAWBIndex").item(m+1).Value = ""  then
			document.all("HAWBCheck" & m).item(i+1).checked=False
		end if
	next
	for i=0 to NoFile-1
		On Error Resume Next
		document.all("AgentFileCheck" & m).item(i+1).checked=False
	next
end If

end Sub

/////////////////////////////////
Sub UploadClick(OrgNo)
/////////////////////////////////
	if Not OrgNo="" then
		if document.all("File" & OrgNo).Value="" then
			MsgBox "Please select a file to upload!"
			exit Sub
		end if
		document.form1.action="pre_alert.asp?UP=yes&UpOrgNo=" & OrgNo
		document.form1.method="POST"
		document.form1.target="_self"
		form1.submit()
	end if
End Sub

Sub DeleteFile(OrgNo, dFileName)

// by iMoon DEC/01/2006 /////////////////////////////////
		document.form1.hDeleteFileName.value = dFileName
/////////////////////////////////////////////////////////

		document.form1.action="pre_alert.asp?RM=yes&UpOrgNo=" & OrgNo & "&dFileName=" & dFileName
		document.form1.method="POST"
		document.form1.target="_self"
		form1.submit()
End Sub
Sub MenuMouseOver()
  document.form1.lstMAWB.style.visibility="hidden"
End Sub
Sub MenuMouseOut()
  document.form1.lstMAWB.style.visibility="visible"
End Sub
Sub ShowEmailHistory

    jPopUpNormal()
	document.form1.action= "../../ASPX/MISC/EmailHistory.aspx?title=Agent Pre-Alert&ao=A&ie=E"
	document.form1.method="post"
	document.form1.target="popUpWindow"
	
	form1.submit()
	
End Sub
</script>
<!-- //for Tooltip// -->
<script language="JavaScript" type="text/javascript" src="../include/tooltips.js"></script>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>