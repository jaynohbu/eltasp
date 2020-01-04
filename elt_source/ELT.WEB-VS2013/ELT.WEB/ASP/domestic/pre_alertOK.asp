<%@ LANGUAGE = VBScript %>
<html>
<head>
<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>	
<title>Pre-Alert</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
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
Dim rs,SQL
Dim aMAWB(2000),aAgentName(32),aAgentNo(32),aAgentEmail(32),aAgentCheck(32),aAgentCC(32),aAgentMSG(32)
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
Dim NoItem,aAgentPDFName(32),aConsigneeCheck(32),PDFNameForDB,testFileSize,fileSizeLimit

fileSizeLimit = 3000000
Send=Request.QueryString("Send")
Edit=Request.QueryString("Edit")
UP=Request.QueryString("UP")
RM=Request.QueryString("RM")
dFileName=Request.QueryString("dFileName")

if Edit="yes" or Send="yes" or UP="yes" Or RM="yes" then
	Dim objUpload
	Dim strFileName
	Dim objConn
	Dim objRs
	Dim lngFileID

' Instantiate Upload Class
	Set objUpload = New clsUpload
	vMAWB=objUpload("lstMAWB").Value
	vMAWB=Mid(vMAWB,1,len(vMAWB)-2)
	vYourName=objUpload("txtYourName").Value
	vYourName=Mid(vYourName,1,len(vYourName)-2)
	vYourEmail=objUpload("txtYourEmail").Value
	vYourEmail=Mid(vYourEmail,1,len(vYourEmail)-2)
	
end if

Set rs=Server.CreateObject("ADODB.Recordset")
Set rs1=Server.CreateObject("ADODB.Recordset")
if Edit="yes" Then

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
if Not vMAWB="" then
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

'/////////////////////////
if  rs.EOF then
'/////////////////////////

		rs.close
		vHAWB=""

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


		SQL= "select invoice_no from invoice where elt_account_number = " & elt_account_number & " and MAWB_NUM = '" & vMAWB & "'"
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
			SQL= "select invoice_no,amount_charged from invoice where elt_account_number = " & elt_account_number & " and MAWB_NUM = '" & vMAWB & "' and customer_number=" & vAgentNo
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


			aManifest(aIndex)="MAWB=" & vMAWB & "&Agent=" & vAgentNo & "&MasterAgentNo=" & MasterAgentNo & "&AgentName=" & vAgentName & "&MasterAgentName=" & MasterAgentName & "&MasterAgentPhone=" & MasterAgentPhone

			if Edit="yes" then			
				aManifestCheck(aIndex)="Y"
				aMAWBAgentCheck(aIndex)="Y"
			else

				aManifestCheck(aIndex)=Mid(objUpload("cManifestCheck" & aIndex).Value,1,1)
				aMAWBAgentCheck(aIndex)=Mid(objUpload("cMAWBAgentCheck" & aIndex).Value,1,1)

			end if
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
		SQL= "delete from user_files where elt_account_number = " & elt_account_number & " and org_no=" & UpOrgNo & " and file_name='" & dFileName & "'"
		eltConn.Execute SQL
	end if
' get agent attached files
	for i=0 to aIndex-1
		SQL= "select file_name,file_checked from user_files where elt_account_number=" & elt_account_number & " and org_no=" & aAgentNo(i) & " order by file_name"
		rs.Open SQL, eltConn, , , adCmdText
		afIndex=0
		Do while Not rs.EOF
			vFileName=rs("file_name")
			aAgentFileURL(i,afIndex)="http://" & Request.ServerVariables("SERVER_Name") & "/ASP/include/viewfile.asp?OrgNo=" & aAgentNo(i) & "&FileName=" & vFileName
			aAgentFileName(i,afIndex)=vFileName
			aAgentFileCheck(i,afIndex)=rs("file_checked")
			rs.MoveNext
			afIndex=afIndex+1
		loop
		rs.Close
		aAgentFileIndex(i)=afIndex
	next
end if

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

'		if not aAgentNo(m)="" And Not aAgentEmail(m)="" And aAgentCheck(m)="Y" then
		if not aAgentNo(m)="" And aAgentCheck(m)="Y" then
			AttachedFileName=temp_path & "\Eltdata\" & elt_account_number & "\agentmail" & aAgentNo(m) & ".pdf"
			PDFNameForDB=elt_account_number & "\agentmail" & aAgentNo(m) & ".pdf"
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
			if Not vMAWB="" and Not checkBlank(aAgentELTAcct(m),0)=0 and Not aOnlineAlertCheck(m)="" then
				SQL="select edt from organization where elt_account_number=" & aAgentELTAcct(m) & " and agent_elt_acct=" & elt_account_number
'response.write SQL
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
				if Not vMAWB="" and not aHAWB(m,n)="" and Not checkBlank(aAgentELTAcct(m),0)=0 and Not aOnlineAlertCheck(m)="" then
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
				'aHAWBCheck(m,n)=Request("cHAWBCheck" & m & "," & n)
				if aHAWBCheck(m,n)="Y" then
					HAWBtmp=aHAWB(m,n)
					Call InsertHAWBIntoPDF(HAWBtmp,"CONSIGNEE")
					Attachment="Y"
				end if
			next
' insert to import_mawb table for import agent

			if Not vMAWB="" and Not checkBlank(aAgentELTAcct(m),0)=0 and Not aOnlineAlertCheck(m)="" and vEDT="Y" then
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

' insert invoice to pdf file
			'aInvoiceCheck(m)=Request("cInvoiceCheck" & m)
			if Not aInvoiceCheck(m)="" and Not vMAWB="" then
				Call InsertInvoiceIntoPDF(aInvoice(m))
				Attachment="Y"
			end if
' insert agent stmt to pdf file
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

'////////////////////////////////////////////////////////////

			Mail.From="preAlert@e-logitech.net"
			Mail.FromName="Air Export Pre-Alert"

fHTML = true

If fHTML = True then
'// HTML Format
			aAgentMSG(m) = Replace(aAgentMSG(m),Chr(13),"<br>")	
			str="<html xmlns='http://www.w3.org/1999/xhtml><head><meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' /><title>Untitled Document</title><style type='text/css'><!--.text {font-family: Verdana, Arial, Helvetica, sans-serif;	font-size: 0.85em;}--></style></head><body><p class='text'><font color='#f39003'><strong>DOMESTIC PRE-ALERT</strong></font></p><p class='text'>"
			str=str & aAgentMSG(m)
			str=str & "</p><br><br><br><p class='text'>This message was sent by E-LOGISTICS TECHNOLOGY on behalf of <a href='mailto:"&vYourEmail&"'>" & vYourName & "</a>.<br>"
			str=str & "If you would like to reply to this message, please click on the following link:<br /><a href='mailto:"&vYourEmail&"'>" & vYourEmail & "</a>.</p><a href='http://e-logitech.net' target='_blank'><img src='http://www.e-logitech.net:8080/elt_email/images/powered_logo.gif' width='123' height='50' border='0' /></a></body></html>"
			Mail.IsHTML=True
else
'// Plain Text
			str=aAgentMSG(m)
End if

			Mail.Body=str
			Mail.Subject=aAgentSubject(m)
			
'////////////////////////////////////////////////////////////
			Call ADD_TO_MAIL(Mail, checkBlank(aAgentEmail(m),""))
			Call ADD_CC_MAIL(Mail, checkBlank(aAgentCC(m),""))

			if Not AttachedFileName="" And Attachment="Y" then
				Mail.AddAttachment AttachedFileName
				aAgentPDFName(m) = "agentmail" & aAgentNo(m) & ".pdf"
				for n=0 to aAgentFileIndex(m)-1
					'aAgentFileCheck(m,n)=Mid(objUpload("cAgentFileCheck" & m & "," & n).Value,1,1)
					vDest=temp_path & "\Eltdata\" & elt_account_number & "\" & aAgentNo(m)
					if aAgentFileCheck(m,n)="Y" then
						Call SaveBinaryFile(aAgentNo(m),aAgentFileName(m,n))
						testFileSize = FileLen(vDest & "\" & aAgentFileName(m,n))
						If testFileSize < fileSizeLimit Then
						    Mail.AddAttachment vDest & "\" & aAgentFileName(m,n)
						Else
%>
<table width="100%" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center" class="text">
        <%=aAgentFileName(m,n) %> exceeded filesize limit (3MB)
    </td>
  </tr>
</table>
<%
                            aAgentFileName(m,n) = ""
					    End If
					end if
				next
			end if

			On Error Resume Next
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
    <td align="center" class="text"><span class="style1">eMail was not sent!</span></td>

   <p class="text" align="center"><%
				Response.Write("Agent " & aAgentName(m) & " Failed with Error # " & CStr(Err.Number) & " " & Err.Description & "")
				Err.Clear
	%></p>

	</td>
  </tr>

  <%
			else

	%>

  <tr>
    <td align="center" class="text"><font color="#3366CC">eMail was sent successfully!</font></td>
  </tr></td></tr>
  <tr>
    <td align="center" class="text">
      <%
				Response.Write("(Agent: " & aAgentName(m)  & ")")
%>
    </td>
  </tr>
  <%
			end if
%>
<%			Set Mail=Nothing
		end if
	next
	set PDF=nothing
end If

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
  
  Call UpdateEmailHistory("A","E","Pre-Alert")
%>
<!-- #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!-- #INCLUDE FILE="../include/emailTracking.inc" -->
<!-- #INCLUDE FILE="../include/StatusFooter.asp" -->

</html>
