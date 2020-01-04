<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/PDFManager.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_fun.inc" -->
<% 

    '// Copied from header.asp /////////////////////////////////////////////////////
    
    Dim elt_account_number,login_name,user_id,ClientOS,session_ip,session_IntIp
    Dim session_server_name,session_user_lname,redPage
	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	login_name = Request.Cookies("CurrentUserInfo")("login_name")
	user_id = Request.Cookies("CurrentUserInfo")("user_id")
	ClientOS = Request.Cookies("CurrentUserInfo")("ClientOS")
	session_ip = Request.Cookies("CurrentUserInfo")("IP")
	session_IntIp = Request.Cookies("CurrentUserInfo")("intIP")
	session_server_name = Request.Cookies("CurrentUserInfo")("Server_Name")
	session_user_lname = Request.Cookies("CurrentUserInfo")("lname")
	redPage = Request.Cookies("CurrentUserInfo")("ORIGINPAGE")
	
	'////////////////////////////////////////////////////////////////////////////////
Dim vWDate,vWRecNo,vWrNum,nSNum,vCBNo
Dim vReceivedFromName,vReceivedFromPho,vReceivedFromFax
Dim vAccountInfoName,vAccountInfoPho,vAccountInfoFax
Dim vDeliveredByName,vDeliveredByPho,vDeliveredByFax
Dim vReceivedfromadd,vDeliveredByadd,vAccountInfoadd
Dim vReceivedfromzip,vDeliveredByzip,vAccountInfozip
Dim vReceivedfromcity,vDeliveredBycity,vAccountInfocity
Dim vReceivedfromstate,vDeliveredBystate,vAccountInfostate
Dim vReceivedfromcountry,vDeliveredBycountry,vAccountInfocountry
Dim vFFaddress,vFFname,vCusRefNo,vPP,vCO,vCODAmt
Dim vHandlingInfo,vYes,vNo,vRecDate,vAvaPickD
Dim vStorageD,vNoOPkg,vDesOfArtSpMarkExce
Dim vWeight, vDimension,vRemark,vAutoUid
DIm vRecNum,vCusNum,vDelNum,vInlandType
Dim vDangerGood,vWeightS,vDimensionS,vWRNUM2
Dim vReceivedfromadd2,vAccountInfoadd2,v_contact
Dim v_contact2,v_contact3,vcontact,vPO_NO
'/////////////////////////////////////////////////// by ig NOV-27

vMAWB=Request.QueryString("MAWB")
v_contact2=Request.form("txtReceivedFromInfo")
v_contact3=Request.form("hAccountOfInfoPDF")
vDeliveredByName=Request.form("lstTruckerName")
v_contact=Request.form("txtTruckerInfo")

'vSNum=Request.QueryString("lstSearchNum")
vWRNUM2=Request.form("lstSearchNum")
'vWRNum=Request.QueryString("txtWRNum")
if UserRight=1 then Copy="CONSIGNEE"
Dim rsHAWB, SQL,rs
Set rsHAWB = Server.CreateObject("ADODB.Recordset")

'// added by Joon on Jan/16/2007 /////////////////////////////////////////////
Dim vSTMT1,vSTMT2

User_country = checkBlank(Session("user_country"),"US")

SQL= "select * from form_stmt where form_name='awb' and country='" & User_country & "' order by stmt_name"
rsHAWB.Open SQL, eltConn, , , adCmdText
Do While Not rsHAWB.EOF
	vSTMTName=rsHAWB("stmt_name")
	if vSTMTName="stmt1" then
		vSTMT1=rsHAWB("stmt")
	end if
	if vSTMTName="stmt2" then
		vSTMT2=rsHAWB("stmt")
	end if
	rsHAWB.MoveNext
Loop
rsHAWB.Close


'////////////////////////////////////////////////////////////////////////////

SQL= "select * from warehouse_receipt where elt_account_number = " & elt_account_number & " and wr_num ='" & vWRNUM2 &"'" 
rsHAWB.Open SQL, eltConn, , , adCmdText
		Do While Not rsHAWB.EOF 
	If IsNull(rsHAWB("wr_num")) = False Then
		vWRNum = rsHAWB("wr_num")
	End If	
	If IsNull(rsHAWB("created_date")) = False Then
		vWDate = rsHAWB("created_date")
	End If
	If IsNull(rsHAWB("auto_uid")) = False Then
		vAutoUid= rsHAWB("auto_uid")
	End If
	If IsNull(rsHAWB("shipper_acct")) = False Then
		vRecNum= rsHAWB("shipper_acct")
	End If
	If IsNull(rsHAWB("customer_acct")) = False Then
		vCusNum= rsHAWB("customer_acct")
	End If
	If IsNull(rsHAWB("trucker_acct")) = False Then
		vDelNum= rsHAWB("trucker_acct")
	End If	
	If IsNull(rsHAWB("carrier_ref_no")) = False Then
		vCBNo= rsHAWB("carrier_ref_no")
	End If
	If IsNull(rsHAWB("inland_type")) = False Then
		vInlandType= rsHAWB("inland_type")
	End If					
	If IsNull(rsHAWB("inland_amount")) = False Then
		vCODAmt= rsHAWB("inland_amount")
	End If		
	If IsNull(rsHAWB("customer_ref_no")) = False Then
		vCusRefNo= rsHAWB("customer_ref_no")
	End If
	If IsNull(rsHAWB("danger_good")) = False Then
		vDangerGood= rsHAWB("danger_good")
	End If
	If IsNull(rsHAWB("received_date")) = False Then
		vRecDate=rsHAWB("received_date")
	End If
	If IsNull(rsHAWB("pickup_date")) = False Then
		vAvaPickD=rsHAWB("pickup_date")
	End If	
	If IsNull(rsHAWB("storage_date")) = False Then
		vStorageD=rsHAWB("storage_date")
	End If	
	If IsNull(rsHAWB("handling_info")) = False Then
		vHandlingInfo=rsHAWB("handling_info")
	End If	
	If IsNull(rsHAWB("item_piece_origin")) = False Then
		vNoOPkg=rsHAWB("item_piece_origin")
	End If	
	If IsNull(rsHAWB("item_desc")) = False Then
		vDesOfArtSpMarkExce=rsHAWB("item_desc")
	End If
	If IsNull(rsHAWB("item_weight")) = False Then
		vWeight=rsHAWB("item_weight")
	End If	
	If IsNull(rsHAWB("item_weight_scale")) = False Then
		vWeightS=rsHAWB("item_weight_scale")
	End If	
	If IsNull(rsHAWB("item_dimension")) = False Then
		vDimension=rsHAWB("item_dimension")
	End If	
	If IsNull(rsHAWB("item_dimension_scale")) = False Then
		vDimensionS=rsHAWB("item_dimension_scale")
	End If	
	If IsNull(rsHAWB("item_remark")) = False Then
		vRemark=rsHAWB("item_remark")
	End If						
		If IsNull(rsHAWB("customer_contact")) = False Then
		vcontact=rsHAWB("customer_contact")
	End If
		If IsNull(rsHAWB("PO_NO")) = False Then
		vPO_NO=rsHAWB("PO_NO")
	End If
	
	
	rsHAWB.MoveNext	
Loop
rsHAWB.Close




response.buffer = True

DIM oFile
oFile = Server.MapPath("../template")
Set PDF =GetNewPDFObject()
r = PDF.OpenOutputFile("MEMORY")
r = PDF.OpenInputFile(oFile+"/warehouse_receipt.pdf")


Dim vMAWB2
vMAWB2 = vMAWB
'////////////////////////////////////////////////////////////////
vMAWB=mid(vMAWB,1,3) & "   " & AirportCode & "  " & mid(vMAWB,5,30)


PDF.SetFormFieldData "W_Date",vWDate,0
PDF.SetFormFieldData "W_Rec_no",vWRNum,0
PDF.SetFormFieldData "Revceived_From_Name",vReceivedfromname,0
PDF.SetFormFieldData "received_from",v_contact2,0
PDF.SetFormFieldData "Account_Info_Name",vAccountInfoname,0
PDF.SetFormFieldData "for_account_of",v_contact3,0
PDF.SetFormFieldData "Delivered_by_Name",vDeliveredByname,0
PDF.SetFormFieldData "contect_NO",v_contact,0
PDF.SetFormFieldData "contact",vcontact,0
PDF.SetFormFieldData "C_B_No",vCBNo,0
PDF.SetFormFieldData "COD_Amt",FormatAmount(vCODAmt),0
PDF.SetFormFieldData "Cus_Ref_No",vCusRefNo,0
PDF.SetFormFieldData "ff_Name",GetAgentName(elt_account_number),0
PDF.SetFormFieldData "ffaddress",GetAgentAddress(elt_account_number),0
PDF.SetFormFieldData "Handling_info",vHandlingInfo,0
PDF.SetFormFieldData "Rec_date",vRecDate,0
PDF.SetFormFieldData "AVA_pick_D",vAvaPickD, 0
PDF.SetFormFieldData "No_O_PKG",vNoOPkg,0
PDF.SetFormFieldData "Storage_start_D",vStorageD,0
PDF.SetFormFieldData "DesOfArtSpMarkExce",vDesOfArtSpMarkExce,0
PDF.SetFormFieldData "Weight",vWeight,0
PDF.SetFormFieldData "Weight_S",vWeightS,0
PDF.SetFormFieldData "Dimension",vDimension,0
PDF.SetFormFieldData "Dimension_S",vDimensionS,0
PDF.SetFormFieldData "Dam_Exc",vRemark,0
PDF.SetFormFieldData "PO_NUM",vPO_NO,0
'////////////////////////////////////////////////////////////////

If Not vInlandType ="" Then
If vInlandType ="P" then
PDF.SetFormFieldData "PP","X",0
Else
PDF.SetFormFieldData "Co","X",0
End If
end if

If Not vDangerGood ="" Then
If vDangerGood ="Y" then
PDF.SetFormFieldData "YES","X",0
else
PDF.SetFormFieldData "NO","X",0 
End If
end if
'PDF.SetHeaderFont "Helvetica", 8
	

logOFile = Server.MapPath("../template")
r = PDF.AddLogo(logOFile &  "/logo/Logo" & elt_account_number & ".pdf",1)

R=PDF.CopyForm(0, 0)
PDF.CloseOutputFile

response.expires = 0
response.clear
response.ContentType = "application/pdf"
response.AddHeader "Content-Type", "application/pdf"
response.AddHeader "Content-Disposition", "attachment; filename=WHR" & Session.SessionID & ".pdf"
WritePDFBinary(PDF)
set PDF=nothing


Sub ExecutionStringChange
    Dim txtPos
    txtPos = InStr(UCase(vExecute),"AS AGENT OF")
    If txtPos>0 Then
		If InStr(vExecute,"CARRIER") = 0 Then
			vExecute = Left(vExecute, txtPos) & Replace(vExecute, chr(13), ", CARRIER" & chr(13), txtPos + 1, 1)
		End If
    End If
End Sub


Function FormatAmount (argStrVal)
    Dim returnVal
	If Not IsNull(argStrVal) And Trim(argStrVal) <> "" Then
		argStrVal = Trim(argStrVal)
		If isnumeric(argStrVal) And Not isempty(argStrVal) Then
			If argStrVal <> "0" Then
				returnVal = FormatNumber(argStrVal,2)
			End If
		Else
			returnVal = argStrVal
		End If
	Else
		returnVal = ""
	End If
	FormatAmount = returnVal
End Function



%>


