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

    Dim rs,SQL
    Set rs = Server.CreateObject("ADODB.Recordset")
    dim Is_Master
    Dim vHBOL,vMBOL,vBookingNum,vAgentName,vAgentInfo,vAgentAcct
    Dim vShipperName,vShipperInfo,vShipperAcct
    Dim Shipper(4),Consignee(4),Agent(3),Notify(4)
    Dim vConsigneeName,vConsigneeInfo,vConsigneeAcct,vNotifyInfo
    Dim vExportRef,vOriginCountry,vExportInstr,vLandingPier,vMoveType
    Dim ExportRef(3),ExportInstr(6)
    Dim vConYes,vPreCarriage,vPreReceiptPlace
    Dim vExportCarrier,vLandingPort,vUnloadingPort,vDepartureDate
    Dim vDeliveryPlace,vDesc1,vDesc2,vDesc3,vPieces,vWeightCP,vGrossWeight
    Dim Desc1(13),Desc2(13),Desc3(13),Desc5(5)
    Dim vMeasurement
    Dim vWidth,vLength,vHeight,vChargeableWeight,vChargeRate
    Dim vTotalWeightCharge
    Dim vShowPrepaidWeightCharge,vShowCollectWeightCharge
    Dim vShowPrepaidOtherCharge,vShowCollectOtherCharge
    Dim vOtherChargeCP,vChargeItem,vChargeAmt,vVendor,vCost
    Dim vDeclaredValue,vBy,vDate,vPlace
    Dim aChargeCP(10),aChargeItem(10),aChargeAmt(10),aChargeVendor(10),aChargeCost(10)
    Dim aChargeNo(10),aChargeItemName(10)
    Dim vTotalPrepaid,vTotalCollect,vCOLO,vAESText

    Save=Request.QueryString("Save")
    Add=Request.QueryString("Add")
    Edit=Request.QueryString("Edit")
    Delete=Request.QueryString("Delete")
    vHBOL=Request.QueryString("HBOL")

    '////////////////////////////////////////// by ig
    Dim vExportAgentELTAcct,Copy
    
    vExportAgentELTAcct = Request.QueryString("AgentELTAcct")
    
    if Not vExportAgentELTAcct = "" then 
	    elt_account_number = vExportAgentELTAcct
	    UserRight=1
    end if
    
    if UserRight=1 then Copy="CONSIGNEE"

    if Not vHBOL = "" then
	    SQL= "select * from hbol_master where elt_account_number = " & elt_account_number & " and hbol_num=N'" & vHBOL & "'"
	    rs.Open SQL, eltConn, , , adCmdText
	    vConYes="Y"
	    vDate= now
	    vTotalPrepaid=0
	    vTotalCollect=0
	    
	    if Not rs.EOF then
	        Is_Master = checkBlank(rs("is_master"),"N")
		    vBookingNum = rs("booking_num")
		    vMBOL = rs("mbol_num")
		    vShipperName = rs("shipper_name")
		    vShipperInfo = rs("shipper_info")
		    vShipperAcct = checkBlank(rs("shipper_acct_num").value,0)
		    vConsigneeName = rs("consignee_name")
		    vConsigneeInfo = rs("consignee_info")
		    vConsigneeAcct = checkBlank(rs("consignee_acct_num").value,0)
		    vNotifyInfo = rs("notify_info")
		    vExportRef = rs("export_ref")
		    vAgentInfo = rs("forward_agent_info")
		    vOriginCountry = rs("origin_country")
		    vExportInstr = rs("export_instr")
		    vLoadingPier = rs("loading_pier")
		    vMoveType = rs("move_type")
		    vConYes = rs("containerized")
		    If vConYes = "Y" then
			    vConYes = "X"
			    vConNo = ""
		    else
			    vConYes = ""
			    vConNo = "X"
		    end if
		    vPreCarriage = rs("pre_carriage")
		    vPreReceiptPlace = rs("pre_receipt_place")
		    vExportCarrier = rs("export_carrier")
		    vLoadingPort = rs("loading_port")
		    vUnloadingPort = rs("unloading_port")
		    vDeliveryPlace = rs("delivery_place")
		    vDepartureDate = rs("departure_date")
		    vWeightCP = rs("weight_cp")
		    vPieces = rs("pieces")
            vGrossWeight = formatNumberPlus(checkBlank(rs("gross_weight").value,0),2)
            vLb = Round(vGrossWeight*2.204,2)
            vMeasurement = formatNumberPlus(checkBlank(rs("measurement").value,0),2)
            vCF = Round(vMeasurement*35.31,2)
		    vDesc6=vGrossWeight & " KG" & "  " & vMeasurement & " CBM"
		    vDesc7=vLb & " LB" & "  " & vCF & " CF"
		    vTotalWeightCharge=formatNumberPlus(checkblank(rs("total_weight_charge").value,0),2)
		    vDesc1=rs("desc1")
		    vDesc2=rs("desc2")
		    vDesc3=rs("desc3")
		    vCOLO=rs("colo")
    
		    if Not Trim(vDesc3) = "" Then
			    If InStr(vDesc3, "SAID TO CONTAIN") < 0 Then
				    vDesc3 = "SAID TO CONTAIN:" & chr(13) & vDesc3
			    End if
		    end If
    		
		    vDesc4=rs("desc4")
		    vDesc5=rs("desc5")
    		
		    If checkBlank(rs("aes_xtn"), "") <> "" Then
                vAESText = "AES ITN: " & rs("aes_xtn")
                vDesc5 = vDesc5 & chr(13) & vAESText
            Elseif checkBlank(rs("sed_stmt"), "") <> "" Then
                vAESText = rs("sed_stmt")
                vDesc5 = vDesc5 & chr(13) & vAESText
            End If
        
		    vShowPrepaidWeightCharge = rs("show_prepaid_weight_charge")
		    vShowCollectWeightCharge = rs("show_collect_weight_charge")
		    vShowPrepaidOtherCharge = rs("show_prepaid_other_charge")
		    vShowCollectOtherCharge = rs("show_collect_other_charge")
		    vDeclaredValue = FormatAmount(rs("declared_value").value)
		    vDate = rs("tran_date")
		    vBy = rs("tran_by")
		    vPlace = rs("tran_place")
	    end if
	    rs.Close
	    
	    SQL = "select * from hbol_other_charge where elt_account_number = " & elt_account_number & " and hbol_num=N'" & vHBOL & "' order by tran_no"
	    rs.Open SQL, eltConn, , , adCmdText
	    tIndex = 0
	    
	    Do while Not rs.EOF
		    aChargeNo(tIndex) = rs("tran_no")
		    aChargeCP(tIndex) = rs("coll_prepaid")
		    aChargeItem(tIndex) = rs("charge_code")
		    aChargeItemName(tIndex) = rs("charge_desc")
		    aChargeAmt(tIndex) = formatNumberPlus(checkblank(rs("charge_amt"),0),2)

		    if aChargeCP(tIndex) = "P" then
			    if vShowPrepaidOtherCharge = "Y" then
				    vTotalPrepaid = vTotalPrepaid + aChargeAmt(tIndex)
				    aChargeAmt(tIndex) = FormatNumber(aChargeAmt(tIndex), 2)
			    else
				    aChargeAmt(tIndex) = ""
				    aChargeItemName(tIndex) = ""
			    end if
		    else
			    if vShowCollectOtherCharge = "Y" then
				    vTotalCollect = vTotalCollect + aChargeAmt(tIndex)
				    aChargeAmt(tIndex) = FormatNumber(aChargeAmt(tIndex), 2)
			    else
				    aChargeAmt(tIndex) = ""
				    aChargeItemName(tIndex) = ""
			    end if
		    end if
		    
		    rs.MoveNext
		    tIndex = tIndex + 1
	    Loop
	    rs.Close
	    
	    if vWeightCP = "P" then
		    if vShowPrepaidWeightCharge = "Y" then
			    vTotalPrepaid = vTotalPrepaid+vTotalWeightCharge
			    vTotalWeightCharge = FormatNumber(vTotalWeightCharge, 2)
		    else
			    vTotalWeightCharge = ""
		    end if
	    else
		    if vShowCollectWeightCharge = "Y" then
			    vTotalCollect = vTotalCollect + vTotalWeightCharge
			    vTotalWeightCharge = FormatNumber(vTotalWeightCharge, 2)
		    else
			    vTotalWeightCharge = ""
		    end if
	    end if
	    
	    vTotalPrepaid = FormatNumber(vTotalPrepaid,2)
	    vTotalCollect = FormatNumber(vTotalCollect,2)
	    if vTotalPrepaid = "0.00" then vTotalPrepaid = ""
	    if vTotalCollect = "0.00" then vTotalCollect = ""
    end if

    'get country stmt
    Dim company_country 

    company_country_code = CheckBlank(GetSQLResult("SELECT country_code from agent where elt_account_number=" & elt_account_number, null), "US")

    SQL= "select * from form_stmt where form_name='bol' AND country='" & company_country_code & "' order by stmt_name"
    rs.Open SQL, eltConn, , , adCmdText

    Do While Not rs.EOF
	    vSTMTName = rs("stmt_name")
	    if vSTMTName = "stmt1" then
		    vSTMT1 = rs("stmt")
	    end if
	    if vSTMTName = "stmt2" then
		    vSTMT2 = rs("stmt")
	    end if
	    if vSTMTName = "stmt3" then
		    vSTMT3 = rs("stmt")
	    end if
	    if vSTMTName = "stmt4" then
		    vSTMT4 = rs("stmt")
	    end if
	    rs.MoveNext
    Loop
    rs.Close

    Set rs = Nothing
    response.buffer = True

    '// PDF Portion //////////////////////////////////////////////////////

    DIM oFile
    oFile = Server.MapPath("../template")
    Set PDF = GetNewPDFObject()
    r = PDF.OpenOutputFile("MEMORY")
    r = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
    Set fso = CreateObject("Scripting.FileSystemObject")
    Dim CustomerForm
    CustomerForm = oFile & "/Customer/" & "bol_" & elt_account_number & ".pdf"
    
    If fso.FileExists(CustomerForm) Then
	    r = PDF.OpenInputFile(CustomerForm)
    Else
	    r = PDF.OpenInputFile(oFile + "/bol.pdf")
    End If
    
    Set fso = Nothing

	If Not elt_account_number = 20007000 Then
		vDesc3 = vDesc3 + Chr(13) + vSTMT4
	End If

	Dim vDesc3Array, vDesc3ArrayCounter, vDesc3Ext
	vDesc3Array = Split(vDesc3, Chr(13))

	If UBound(vDesc3Array) > 15 Then
		vDesc3 = ""
		For vDesc3ArrayCounter = 0 to 15
			vDesc3 = vDesc3 & vDesc3Array(vDesc3ArrayCounter) & Chr(13)
		Next
		vDesc3Ext = ""
		For vDesc3ArrayCounter = 16 to UBound(vDesc3Array)
			vDesc3Ext = vDesc3Ext & vDesc3Array(vDesc3ArrayCounter) & Chr(13)
		Next
	End If

    '// On Error Resume Next:
    '// Added By Joon on Feb/23/2007
    PDF.SetFormFieldData "PageTitleLeft","", 0
    PDF.SetFormFieldData "PageTitleRight","BILL OF LADING", 0 
    PDF.SetFormFieldData "TopName",GetAgentName(elt_account_number) & "", 0
    PDF.SetFormFieldData "BLCOpy", Request.QueryString("Copy") & "", 0

    '// Air 7 Seas Request
    CarrierSQL = "SELECT carrier_desc FROM ocean_booking_number WHERE ISNULL(carrier_code,0)<>0 AND " _
        & "booking_num=N'" & vBookingNum & "' AND elt_account_number=" & elt_account_number
    PDF.SetFormFieldData "AgentForTheCarrier", GETSQLResult(CarrierSQL, Null), 0

    PDF.SetFormFieldData "ShipperInfo", vShipperInfo, 0
    PDF.SetFormFieldData "ConsigneeInfo", vConsigneeInfo, 0
    PDF.SetFormFieldData "NotifyInfo", vNotifyInfo, 0
    PDF.SetFormFieldData "PreCarriage", vPreCarriage, 0
    PDF.SetFormFieldData "PreReceiptPlace", vPreReceiptPlace, 0
    PDF.SetFormFieldData "ExportCarrier", vExportCarrier, 0
    PDF.SetFormFieldData "LoadingPort", vLoadingPort, 0
    PDF.SetFormFieldData "DeliveryPlace", vDeliveryPlace, 0
    PDF.SetFormFieldData "UnloadingPort", vUnloadingPort, 0
    PDF.SetFormFieldData "BookingNum", vBookingNum, 0
    PDF.SetFormFieldData "HBOL", vHBOL, 0
    PDF.SetFormFieldData "ExportRef", vExportRef, 0
    PDF.SetFormFieldData "AgentInfo", vAgentInfo, 0
    PDF.SetFormFieldData "OriginCountry", vOriginCountry, 0
    PDF.SetFormFieldData "ExportInstr", vExportInstr, 0
    PDF.SetFormFieldData "LoadingPier", vLoadingPier, 0
    PDF.SetFormFieldData "MoveType", vMoveType, 0
    PDF.SetFormFieldData "ConYes", vConYes, 0
    PDF.SetFormFieldData "ConNo", vConNo, 0
    'weight info
    PDF.SetFormFieldData "Desc1", vDesc1, 0
    PDF.SetFormFieldData "Desc2", vDesc2, 0
    PDF.SetFormFieldData "Desc3", vDesc3, 0
    '// PDF.SetFormFieldData "stmt4", vSTMT4, 0
    If IsNull(vDesc4) Then vDesc4 = ""
    PDF.SetFormFieldData "Desc4", vDesc4, 0
    PDF.SetFormFieldData "Desc5", vDesc5, 0

    PDF.SetFormFieldData "DeclaredValue", vDeclaredValue, 0
    PDF.SetFormFieldData "STMT1", vSTMT1, 0
    PDF.SetFormFieldData "STMT2", vSTMT2, 0
    PDF.SetFormFieldData "STMT3", vSTMT3, 0
    PDF.SetFormFieldData "OTI", GETSQLResult("SELECT OTI_Code FROM agent WHERE elt_account_number=" & elt_account_number, Null), 0
    PDF.SetFormFieldData "OceanFreight", "Ocean Freight", 0

    if vWeightCP="P" then
	    PDF.SetFormFieldData "PrepaidWeightCharge", vTotalWeightCharge,0
    else
	    PDF.SetFormFieldData "CollectWeightCharge", vTotalWeightCharge,0
    end if

    '///////////////////// for Air7Seas
    If formatNumberPlus(checkblank(vTotalWeightCharge,0), 2) > 0 then
	    If vWeightCP = "P" then
		    PDF.SetFormFieldData "prePaidYes", "X", 0
	    Else
		    PDF.SetFormFieldData "collectYes", "X", 0
	    End if
    End if
    '/////////////////////

    '// 10 item limit
    For i=0 to 9
	    PDF.SetFormFieldData "ChargeItemName" & i + 1, aChargeItemName(i), 0
	    If aChargeCP(i)="P" then
		    PDF.SetFormFieldData "PrepaidChargeAmt" & i + 1, aChargeAmt(i), 0
	    Else
		    PDF.SetFormFieldData "CollectChargeAmt" & i + 1, aChargeAmt(i), 0
	    End if
    	
	    '///////////////////// for Air7Seas
	    If formatNumberPlus(checkblank(aChargeAmt(i),0),2) > 0 then
		    If aChargeCP(i)="P" then
			    PDF.SetFormFieldData "prePaidYes", "X", 0
		    Else
			    PDF.SetFormFieldData "collectYes", "X", 0
		    End if
	    End if
	    '/////////////////////
    Next
    
    PDF.SetFormFieldData "TotalPrepaid", vTotalPrepaid, 0
    PDF.SetFormFieldData "TotalCollect", vTotalCollect, 0

    If vColo = "Y" Then
	    PDF.SetFormFieldData "coloaderYes", "X", 0
    Else
	    PDF.SetFormFieldData "shippers_stowlYes", "X", 0
    End if


    PDF.SetFormFieldData "Place", vPlace, 0
    PDF.SetFormFieldData "By", vBy, 0

    if vDate = "" or isnull(vDate) then
	     vDate = now 
    end if
    
    vDate = Month(vDate) & "/" & Day(vDate) & "/" & Year(vDate)
    PDF.SetFormFieldData "Date", vDate, 0

    r = PDF.CopyForm(0, 0)
    PDF.ResetFormFields
    
    
    If UBound(vDesc3Array) > 15 Then '// second page
        r = PDF.OpenInputFile(oFile + "/bol_ext.pdf")

        PDF.SetFormFieldData "Desc3", vDesc3Ext, 0
		PDF.SetFormFieldData "PageNumber", "Page 2", 0
		PDF.SetFormFieldData "HBOL", vHBOL, 0

        r = PDF.CopyForm(0, 0)
        r = PDF.ResetFormFields
    End If

    PDF.CloseOutputFile
    response.expires = 0
    response.clear
    response.ContentType = "application/pdf"
    response.AddHeader "Content-Type", "application/pdf"
    response.AddHeader "Content-Disposition", "attachment; filename=HBOL" & Session.SessionID & ".pdf"
    WritePDFBinary(PDF)
    
    eltConn.Close
    set PDF = nothing
    Set eltConn = Nothing
    Response.End()

%>


