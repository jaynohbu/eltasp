<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/PDFManager.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_fun.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_Util_Ver_2.inc" -->
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

Dim hawbno
Dim rs,SQL
Set rs = Server.CreateObject("ADODB.Recordset")

Dim vHBOL,vMBOL,vBookingNum,vAgentName,vAgentInfo,vAgentAcct
Dim vShipperName,vShipperInfo,vShipperAcct
Dim vConsigneeName,vConsigneeInfo,vConsigneeAcct,vNotifyInfo
Dim vExportRef,vOriginCountry,vExportInstr,vLandingPier,vMoveType
Dim vConYes,vPreCarriage,vPreReceiptPlace
Dim vExportCarrier,vLandingPort,vUnloadingPort,vDepartureDate
Dim vDeliveryPlace,vDesc1,vDesc2,vDesc3,vPieces,vWeightCP,vGrossWeight
Dim vMeasurement,vCarrierDesc
Dim vDeclaredValue,vBy,vDate,vPlace,vColo, vAESText

vBookingNum=Request.QueryString("BookingNum")

if Not trim(vBookingNum)="" then
	SQL= "select * from mbol_master where elt_account_number = " & elt_account_number & " and booking_num=N'" & vBookingNum & "'"
	rs.Open SQL, eltConn, , , adCmdText
	vConYes="Y"
	vDate=Now
	if Not rs.EOF then
		vMBOL=rs("mbol_num")
		vShipperName=rs("shipper_name")
		vShipperInfo=rs("shipper_info")
		vConsigneeName=rs("consignee_name")
		vConsigneeInfo=rs("consignee_info")
		vNotifyInfo=rs("notify_info")
		vExportRef=rs("export_ref")
		vAgentInfo=rs("agent_info")
		vOriginCountry=rs("origin_country")
		vExportInstr=rs("export_instr")
		vLoadingPier=rs("loading_pier")
		vMoveType=rs("move_type")
		vConYes=rs("containerized")
		vPreCarriage=rs("pre_carriage")
		vPreReceiptPlace=rs("pre_receipt_place")
		vExportCarrier=rs("export_carrier")
		vLoadingPort=rs("loading_port")
		vUnloadingPort=rs("unloading_port")
		vDeliveryPlace=rs("delivery_place")
		vDepartureDate=rs("departure_date")
		vPieces=rs("pieces")
		vGrossWeight=cDbl(rs("gross_weight"))
		vLb=Round(vGrossWeight*2.204,2)
		vMeasurement=cDbl(rs("measurement"))
		vCF=Round(vMeasurement/35.3,2)
		vDesc6=vGrossWeight & " KG" & "  " & vMeasurement & " CUM" & chr(13)
		vDesc6=vDesc6 & vLb & " LB" & "  " & vCF & " CF"
		vDesc1=rs("desc1")
		vDesc2=rs("desc2")
		vDesc3=rs("desc3")
		vDesc4=rs("desc4")
		vDesc5=rs("desc5")
		vTotalWeightCharge=formatNumberPlus(checkblank(rs("total_weight_charge").value,0),2)
		vWeightCP = rs("weight_cp")

		If checkBlank(rs("aes_xtn"),"") <> "" Then
            vAESText = "AES ITN: " & rs("aes_xtn")
            vDesc5 = vDesc5 & chr(13) & vAESText
        Elseif checkBlank(rs("sed_stmt"),"") <> "" Then
            vAESText = rs("sed_stmt")
            vDesc5 = vDesc5 & chr(13) & vAESText
        End If
        
		On Error Resume Next:
		vColo=rs("colo")
		vDate=rs("tran_date")
		vBy=rs("tran_by")
		vPlace=rs("tran_place")

	end if
	rs.Close
end if

    Dim aChargeNo(10), aChargeCP(10), aChargeItem(10), aChargeItemName(10), aChargeAmt(10)
    
        SQL = "select * from mbol_other_charge where elt_account_number=" & elt_account_number _
            & " and booking_num=N'" & vBookingNum & "' order by tran_no"
	    rs.Open SQL, eltConn, , , adCmdText

	    tIndex = 0
	    
	    Do while Not rs.EOF
		    aChargeNo(tIndex) = rs("tran_no")
		    aChargeCP(tIndex) = rs("coll_prepaid")
		    aChargeItem(tIndex) = rs("charge_code")
		    aChargeItemName(tIndex) = rs("charge_desc")
		    aChargeAmt(tIndex) = ConvertAnyValue(rs("charge_amt"), "Double", 0)

		    if aChargeCP(tIndex) = "P" then
			    vTotalPrepaid = vTotalPrepaid + aChargeAmt(tIndex)
                aChargeAmt(tIndex) = FormatNumber(aChargeAmt(tIndex), 2)
		    else
			    vTotalCollect = vTotalCollect + aChargeAmt(tIndex)
                aChargeAmt(tIndex) = FormatNumber(aChargeAmt(tIndex), 2)
		    end if
		    
		    rs.MoveNext
		    tIndex = tIndex + 1
	    Loop
	    rs.Close
	    
		If vWeightCP = "P" Then
			vTotalPrepaid = vTotalPrepaid + vTotalWeightCharge
		Else
			vTotalCollect = vTotalCollect + vTotalWeightCharge
		End If

        vTotalWeightCharge = FormatNumber(vTotalWeightCharge, 2)
	    vTotalPrepaid = FormatNumber(vTotalPrepaid,2)
	    vTotalCollect = FormatNumber(vTotalCollect,2)

	    if vTotalPrepaid = "0.00" then vTotalPrepaid = ""
	    if vTotalCollect = "0.00" then vTotalCollect = ""
	    
	    
'// Added by Joon Feb/06/2007 ///////////////////////////////////////////
'// Get Carrier info. from ocean booking ////////////////////////////////
Call GetCarrierDesc
'////////////////////////////////////////////////////////////////////////

response.buffer = True
Set rs = Nothing


DIM oFile
oFile = Server.MapPath("../template")

Set PDF =GetNewPDFObject()
r = PDF.OpenOutputFile("MEMORY")

'/////////////////////////////////////////////////////////////////////////
Set fso = CreateObject("Scripting.FileSystemObject")
Dim CustomerForm
CustomerForm=oFile & "/Customer/" & "bol_" & elt_account_number & ".pdf"

If fso.FileExists(CustomerForm) Then
'// Customer has a specific bol form
	r = PDF.OpenInputFile(CustomerForm)

Else
'// Normal Form
	r = PDF.OpenInputFile(oFile+"/bol.pdf")
End If
Set fso = nothing
'////////////////////////////////////////////////////////////////////////

'general info

On Error Resume Next:
'// Added By Joon on Feb/23/2007
PDF.SetFormFieldData "PageTitleLeft","MASTER BILL OF LADING",0
PDF.SetFormFieldData "PageTitleRight","INSTRUCTION",0  
PDF.SetFormFieldData "TopName",GetAgentName(elt_account_number) & "",0


'// Air 7 Seas Request
CarrierSQL = "SELECT carrier_desc FROM ocean_booking_number WHERE ISNULL(carrier_code,0)<>0 AND " _
    & "booking_num=N'" & vBookingNum & "' AND elt_account_number=" & elt_account_number
PDF.SetFormFieldData "AgentForTheCarrier", GETSQLResult(CarrierSQL, Null), 0

PDF.SetFormFieldData "Instruction","INSTRUCTION",0
PDF.SetFormFieldData "ShipperInfo",vShipperInfo,0
PDF.SetFormFieldData "ConsigneeInfo",vConsigneeInfo,0
PDF.SetFormFieldData "NotifyInfo",vNotifyInfo,0
PDF.SetFormFieldData "PreCarriage",vPreCarriage,0
PDF.SetFormFieldData "PreReceiptPlace",vPreReceiptPlace,0
PDF.SetFormFieldData "ExportCarrier",vExportCarrier,0
PDF.SetFormFieldData "LoadingPort",vLoadingPort,0
PDF.SetFormFieldData "DeliveryPlace",vDeliveryPlace,0
PDF.SetFormFieldData "UnloadingPort",vUnloadingPort,0
PDF.SetFormFieldData "BookingNum",vBookingNum,0
PDF.SetFormFieldData "HBOL",vMBOL,0
PDF.SetFormFieldData "ExportRef",vExportRef,0
PDF.SetFormFieldData "AgentInfo",vAgentInfo,0
PDF.SetFormFieldData "OriginCountry",vOriginCountry,0
PDF.SetFormFieldData "ExportInstr",vExportInstr,0
PDF.SetFormFieldData "LoadingPier",vLoadingPier,0
PDF.SetFormFieldData "MoveType",vMoveType,0
PDF.SetFormFieldData "ConYes",vConYes,0
PDF.SetFormFieldData "ConNo",vConNo,0
'weight info
PDF.SetFormFieldData "Desc1",vDesc1,0
PDF.SetFormFieldData "Desc2",vDesc2,0
PDF.SetFormFieldData "Desc3",vDesc3,0
PDF.SetFormFieldData "stmt4",vSTMT4,0
If IsNull(vDesc4) Then vDesc4 = ""
PDF.SetFormFieldData "Desc4",vDesc4,0
PDF.SetFormFieldData "Desc5",vDesc5,0
'PDF.SetFormFieldData "WeightKG",vGrossWeight & " KG",0
'PDF.SetFormFieldData "WeightLB",vLb & " LB",0
'PDF.SetFormFieldData "MeasureCBM",vMeasurement & " CBM",0
'PDF.SetFormFieldData "MeasureCF",vCF & " CF",0
PDF.SetFormFieldData "DeclaredValue",vDeclaredValue,0
PDF.SetFormFieldData "STMT1",vSTMT1,0
PDF.SetFormFieldData "STMT2",vSTMT2,0
PDF.SetFormFieldData "STMT3",vSTMT3,0
PDF.SetFormFieldData "OTI", GETSQLResult("SELECT OTI_Code FROM agent WHERE elt_account_number=" & elt_account_number, Null), 0
PDF.SetFormFieldData "OceanFreight", "OCEAN FREIGHT", 0

	if vWeightCP="P" then
	    PDF.SetFormFieldData "PrepaidWeightCharge", vTotalWeightCharge,0
    else
	    PDF.SetFormFieldData "CollectWeightCharge", vTotalWeightCharge,0
    end If
    
'// 10 item limit
    For i=0 to 9
	    PDF.SetFormFieldData "ChargeItemName" & i + 1, aChargeItemName(i), 0
	    If aChargeCP(i)="P" then
		    PDF.SetFormFieldData "PrepaidChargeAmt" & i + 1, aChargeAmt(i), 0
	    Else
		    PDF.SetFormFieldData "CollectChargeAmt" & i + 1, aChargeAmt(i), 0
	    End if
    Next
    
    PDF.SetFormFieldData "TotalPrepaid", vTotalPrepaid, 0
    PDF.SetFormFieldData "TotalCollect", vTotalCollect, 0
    
    
If Not IsNull(vPlace) then
PDF.SetFormFieldData "Place",vPlace,0
End If
If Not IsNull(vBy) then
PDF.SetFormFieldData "By",vBy,0
End If

On error resume Next:
if vDate = "" or isnull(vDate) then
	 vDate=now 
end if
vDate= Month(vDate) & "/" & Day(vDate) & "/" & Year(vDate)
PDF.SetFormFieldData "Date",vDate,0

'//////////////////////////////////////
On error resume Next:
if vColo = "Y" then
	PDF.SetFormFieldData "coloaderYes","X",0
else
	PDF.SetFormFieldData "shippers_stowlYes","X",0
end if
'//////////////////////////////////////

'// PDF.SetHeaderFont "Helvetica", 8
R = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
R = PDF.CopyForm(0, 0)
PDF.CloseOutputFile

response.expires = 0
response.clear
response.ContentType = "application/pdf"
response.AddHeader "Content-Type", "application/pdf"

response.AddHeader "Content-Disposition", "attachment; filename=BOL" & Session.SessionID & ".pdf"

WritePDFBinary(PDF)
set PDF = nothing
eltConn.Close()
Set eltConn = Nothing


'// Added by Joon Feb/06/2007 ///////////////////////////////////////////
Sub GetCarrierDesc()
    vCarrierDesc = ""
    
    SQL = "SELECT carrier_desc FROM ocean_booking_number WHERE elt_account_number=" _
        & elt_account_number & "AND booking_num=N'" & vBookingNum & "'"
    rs.Open SQL, eltConn, , , adCmdText
    
    If Not rs.EOF And Not rs.BOF Then
         vCarrierDesc = rs("carrier_desc").value
    End If
    rs.Close()
End Sub
'////////////////////////////////////////////////////////////////////////

%>


