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
	
Dim vSDate,vWRecNo,vWrNum,nSNum,vCBNo,vACCNO
Dim vAccountInfo,AWr_Num(100),AOrg(100),AOnH(100)
Dim ASo(100),ADes(100),ARec_Date(100),ADim(100),oh(100)
Dim ADam(100),ACus_ref(100),TotalShip,TotalOrg,TotalOnH,TotalS
Dim vPickupName,vDeliveredByPho,vDeliveredByFax,APONO(100)
Dim vFFaddress,vFFname,vCusRefNo,vPONO,vCustomer_ref
Dim vHandlingInfo,vYes,vNo,vRecDate,vshipDate
Dim vNoOPkg,vDesOfArtSpMarkExce
Dim vWeight, vDimension,vRemark,vAutoUid
DIm vRecNum,vCusNum,vDelNum,vInlandType
Dim vWRNUM2,vWHnum,vPO_NO
Dim vAccountInfoadd2,vcontect
Dim vcontect2,vcontect3,vcontact,vPicNUM,onhand(100)
'/////////////////////////////////////////////////// by ig NOV-27

'vSNum=Request.QueryString("lstSearchNum")
vExportAgentELTAcct=Request.QueryString("AgentELTAcct")
if Not vExportAgentELTAcct="" then 
	elt_account_number=vExportAgentELTAcct
	UserRight=1
end if
vSONUM2=Request.form("txtSONum")
vShipoutinfo=Request.form("txtShipToInfo")
vPickUpName=Request.form("lstTruckerName")
vcontect=Request.form("txtTruckerInfo")
vRemarK=Request.form("txtRemarks")
vDimension=Request.form("txtDimension")
vCBNo=Request.form("txtCarrierRefNo")
vNoOPkg=Request.form("txtItemPieces")
vweight=Request.form("txtGrossWeight")
vshipDate=Request.form("txtSODate")
vWHnum=Request.form("lstWareHouseNo")
vPO_NO=Request.form("PO_NO")
vRecDate=Request.form("txtReceivedDate")
vCusRefNo=Request.form("txtCustomerRefNo")
vcontact=Request.form("txtAccountOfContact")
vAccountInfo=Request.form("txtAccountOfInfo")
vSDate=Request.form("txtShipOutDate")
vACCNO=Request.form("hAccountOfAcct")
vPONO=Request.form("txtPONO")
vCustomer_ref=Request.form("txtCustomerRefNo")
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
TotalOrg=0
TotalOnH=0
TotalS=0



             
SQL= "select *,(item_piece_remain + item_piece_shipout) as ONhand from warehouse_history where so_num ='" & vSONUM2 & "'and elt_account_number=" & elt_account_number  
rsHAWB.Open SQL, eltConn, , , adCmdText
dim i
    i=0
    DIM TOrg
		Do While Not rsHAWB.EOF 
	If IsNull(rsHAWB("Wr_num")) = False Then
		AWr_Num(i) = rsHAWB("Wr_num")
	End If	

    If IsNull(rsHAWB("item_piece_shipout")) = False Then 
		ASo(i) = checkBlank(rsHAWB("item_piece_shipout"),0)
		TotalS=TotalS+ASo(i)
	End If	
    If IsNull(rsHAWB("item_piece_remain")) = False Then
		AOnH(i) = checkBlank(rsHAWB("item_piece_remain"),0)

	End If	
	If IsNull(rsHAWB("item_piece_origin")) = False Then
		AOrg(i) = checkBlank(rsHAWB("item_piece_origin"),0)

		
	End If
	
	If IsNull(rsHAWB("ONhand")) = False Then
		onhand(i) = checkBlank(rsHAWB("ONhand"),0)

		
	End If
	i=i+1
	rsHAWB.MoveNext	
Loop


	
rsHAWB.Close
TotalShip=i
TotalW=0



for i = 0 to TotalShip
SQL= "select * from warehouse_receipt where wr_num ='" & AWr_Num(i) & "'and elt_account_number=" & elt_account_number
rsHAWB.Open SQL, eltConn, , , adCmdText
		Do While Not rsHAWB.EOF 
	If IsNull(rsHAWB("received_date")) = False Then
		ARec_Date(i) = checkBlank(rsHAWB("received_date"),0)

	End If
	If IsNull(rsHAWB("item_dimension")) = False Then
		ADim(i) = rsHAWB("item_dimension")
	End If
	If IsNull(rsHAWB("item_remark")) = False Then
		ADam(i) = rsHAWB("item_remark")
	End If
	If IsNull(rsHAWB("item_desc")) = False Then
		ADes(i) = rsHAWB("item_desc")
	End If
	If IsNull(rsHAWB("customer_ref_no")) = False Then
		ACus_ref(i) = rsHAWB("customer_ref_no")
	End If
	If IsNull(rsHAWB("PO_NO")) = False Then
		APONO(i) = rsHAWB("PO_NO")
	End If
	rsHAWB.MoveNext	

Loop

rsHAWB.Close

next







response.buffer = True

DIM oFile
oFile = Server.MapPath("../template_domestic")

Set PDF =GetNewPDFObject()
r = PDF.OpenOutputFile("MEMORY")
r = PDF.OpenInputFile(oFile+"/shipout_report.pdf")

	 ' PDF.SetHeaderFont "Helvetica", 36
   ' t = PDF.GetHeaderTextWidth("Title")
	'  PDF.SetHeaderText (612-t)/2, 550, "TitlePPPP"
'gerenal info


'// Added By Joon On 02/26/2007 /////////////////////////////////
Dim vMAWB2
vMAWB2 = vMAWB
'////////////////////////////////////////////////////////////////
vMAWB=mid(vMAWB,1,3) & "   " & AirportCode & "  " & mid(vMAWB,5,30)


PDF.SetFormFieldData "S_Date",vshipDate,0
PDF.SetFormFieldData "S_Rec_no",vSoNum2,0
PDF.SetFormFieldData "shipout_to_info",vshipoutinfo,0
'///////////////////////////////////////////////
PDF.SetFormFieldData "account_info_Name",GetBusinessName(vACCNO),0
PDF.SetFormFieldData "contect3",GetBusinessTelFax(vACCNO),0
PDF.SetFormFieldData "account_info_address",GetBusinessInfo(vACCNO),0
'///////////////////////////////////////////////
PDF.SetFormFieldData "Pickup_Name",vPickupName,0
PDF.SetFormFieldData "contect_NO",vcontect,0
PDF.SetFormFieldData "ship_date",vSDate,0

'///////////////////////////////////////////////

PDF.SetFormFieldData "contact",vcontact,0
PDF.SetFormFieldData "C_R_No",vCBNo,0
PDF.SetFormFieldData "Cus_Ref_No",vCusRefNo,0
PDF.SetFormFieldData "ff_Name",GetAgentName(elt_account_number),0
PDF.SetFormFieldData "ffaddress",GetAgentAddress(elt_account_number),0
PDF.SetFormFieldData "WareH_Rec_N",vWHNum,0
PDF.SetFormFieldData "Handling_info",vRemark,0
PDF.SetFormFieldData "Rec_date",vRecDate,0
PDF.SetFormFieldData "No_O_PKG",vNoOPkg,0
PDF.SetFormFieldData "DesOfArtSpMarkExce",vDesOfArtSpMarkExce,0
PDF.SetFormFieldData "Weight",vWeight,0
PDF.SetFormFieldData "Dimension",vDimension,0
PDF.SetFormFieldData "Dam_Exc",vHandlingInfo,0
PDF.SetFormFieldData "TotalSHIP",TotalShip,0
PDF.SetFormFieldData "TotH",TotalOnH,0
PDF.SetFormFieldData "TotO",TotalOrg,0
PDF.SetFormFieldData "TotS",TotalS,0
PDF.SetFormFieldData "TotW",TotalW,0
PDF.SetFormFieldData "Customer_ref",vCustomer_ref,0
PDF.SetFormFieldData "po_no",vPONO,0


	for i=0 to 11
		PDF.SetFormFieldData "SO" & i+1,ASo(i),0  
		PDF.SetFormFieldData "org" & i+1,AOrg(i),0
		PDF.SetFormFieldData "wr_num" & i+1,AWr_Num(i),0 
	    PDF.SetFormFieldData "On_H" & i+1,AOnH(i),0  
	    PDF.SetFormFieldData "Rec_Date" & i+1,ARec_Date(i),0  
		PDF.SetFormFieldData "PONO" & i+1,APONO(i),0
		PDF.SetFormFieldData "CUS_REF_NO" & i+1,ACus_ref(i),0 
	    PDF.SetFormFieldData "DesOfArtSpMarkExce" & i+1,ADes(i),0 
	     PDF.SetFormFieldData "HO" & i+1,onhand(i),0 
	next

'////////////////////////////////////////////////////////////////


'PDF.SetHeaderFont "Helvetica", 8
	

logOFile = Server.MapPath("../template")
r = PDF.AddLogo(logOFile &  "/logo/Logo" & elt_account_number & ".pdf",1)

R=PDF.CopyForm(0, 0)
PDF.CloseOutputFile

response.expires = 0
response.clear
response.ContentType = "application/pdf"
response.AddHeader "Content-Type", "application/pdf"
response.AddHeader "Content-Disposition", "attachment; filename=SHO" & Session.SessionID & ".pdf"
WritePDFBinary(PDF)
set PDF=nothing

'//added by joon on Dec/03/2007
Sub ExecutionStringChange
    Dim txtPos
    txtPos = InStr(UCase(vExecute),"AS AGENT OF")
    If txtPos>0 Then
		If InStr(vExecute,"CARRIER") = 0 Then
			vExecute = Replace(vExecute,chr(13),", CARRIER" & chr(13),txtPos,1)
		End If
    End If
End Sub

'// added by Joon on Jan/17/2007
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


