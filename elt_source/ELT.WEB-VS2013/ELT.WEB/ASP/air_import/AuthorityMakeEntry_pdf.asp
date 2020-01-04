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
Dim vMAWB,vAgentName,vFileNum,vCarrier,vPieces,vAgentDebitNo,vAgentDebitAmt
Dim vFLTNo,vETD,vETA,vGrossWeight,vChargeableWeight
Dim vDepPort,vArrPort
Dim vHAWB,vShipperInfo,vConsigneeInfo,vNotifyInfo
Dim NoItem,aItemNo(256),aItemName(256),aDesc(256),aRefNo(256),aAmount(256),aCost(256),aRealCost(256)
Dim aAR(256),aRevenue(256),aExpense(256)
Dim aVendor(256)

Dim vInvoiceNo

On Error Resume Next:

vInvoiceNo=Request.QueryString("invoice_no")

iType=Request.QueryString("iType")
vHAWB=Request.QueryString("HAWB")
'if vHAWB="" then vHAWB="0"
vSec=Request.QueryString("Sec")
if vSec="" then vSec=1
vAgentOrgAcct=Request.QueryString("AgentOrgAcct")
if vAgentOrgAcct="" then vAgentOrgAcct=0
Set rs=Server.CreateObject("ADODB.Recordset")
SQL= "select dba_name,business_address,business_city,business_state,business_zip,business_country,business_phone,business_fax from agent where elt_account_number = " & elt_account_number
rs.Open SQL, eltConn, , , adCmdText	
If Not rs.EOF Then
	vAgentName = rs("dba_name")
	AgentAddress=rs("business_address")
	AgentCity = rs("business_city")
	AgentState = rs("business_state")
	AgentZip = rs("business_zip")
	AgentCountry = rs("business_country")
	AgentPhone=rs("business_phone")
	AgentFax=rs("business_fax")
	vAgentInfo=AgentAddress & chr(13) & AgentCity & "," & AgentState & " " & AgentZip & " " & AgentCountry & chr(13) & "Phone: " & AgentPhone & "  Fax: " & AgentFax
End If
rs.Close
'if Not vHAWB="" then
    if true then 
	'SQL="select a.it_number as itno,a.it_date as itdate,a.it_entry_port as itentryport,a.cargo_location as cl,a.sec as sec,a.*,a.process_dt as process_dt_h,a.mawb_num as mawb_num,b.* from import_hawb a,import_mawb b where a.elt_account_number=b.elt_account_number and a.elt_account_number=" & elt_account_number & " and a.iType=b.iType and a.iType='" & iType & "' and a.mawb_num=b.mawb_num and a.hawb_num='" & vHAWB & "' and a.sec=b.sec order by sec desc"
    SQL="select a.it_number as itno,a.it_date as itdate,a.it_entry_port as itentryport,a.cargo_location as cl,a.sec as sec,a.*,a.process_dt as process_dt_h,a.mawb_num as mawb_num,b.*,isnull(a.dep_port,'') as dep_port_h,isnull(a.arr_port,'') as arr_port_h,a.eta as eta_h,a.etd as etd_h from import_hawb a,import_mawb b where a.elt_account_number=b.elt_account_number and a.elt_account_number=" & elt_account_number & " and a.iType=b.iType and a.iType='" & iType & "' and a.mawb_num=b.mawb_num and a.hawb_num=N'" & vHAWB & "' and a.sec=b.sec and a.invoice_no="&vInvoiceNo

	rs.Open SQL, eltConn, , , adCmdText
	if Not rs.EOF then
'	'	vExportAgentName=rs("export_agent_name")
		vShipperInfo=rs("shipper_info")
		vConsigneeInfo=rs("consignee_info")
		'vConsigneeName=rs("consignee_name")
		vNotifyInfo=rs("notify_info")
		vFileNo=rs("file_no")
		vFLTNo=rs("flt_no")
		vProcessDT=rs("process_dt_h")
		vMAWB=rs("mawb_num")
		vPreparedBy=rs("prepared_by")
		vSubHAWB=rs("igsub_hawb") '// by ig It's used as Sub HAWB Field
		if Isnull(rs("igsub_hawb")) = true then
			vSubHAWB=""
		end if
'//		vSubMAWB2=rs("sub_mawb2")
		vCustomerRef=rs("customer_ref")

'////////////////////////////////// by goofy 6/1/2007

        If rs("dep_port_h").value = "" Then
            vDepPort = GetPortCity(checkBlank(rs("dep_port"),""))
        Else
            vDepPort = checkBlank(GetPortCity(rs("dep_port_h").value),rs("dep_port_h").value)
        End If

		If rs("arr_port_h").value = "" Then
            vArrPort = GetPortCity(checkBlank(rs("arr_port"),""))
        Else
            vArrPort = checkBlank(GetPortCity(rs("arr_port_h").value),rs("arr_port_h").value)
        End If
        
'////////////////////////////////// 
		
		vETD=rs("etd_h")
		if IsNull(vETD) then
			vETD=" "
		end if
		vETA=rs("eta_h")
		if IsNull(vETA) then
			vETA=" "
		end if
'		vVessel=rs("flt_no")
'		if IsNull(vVessel) then
'			vVessel=""
'		end if
		vBrokerInfo=rs("broker_info")
		vDeliveryPlace=rs("delivery_place")
		if IsNull(vDeliveryPlace) then vDeliveryPlace=""
		'vDestination=rs("fdstn")
		vETD2=rs("etd2")
		vETA2=rs("eta2")
		vCargoLocation=rs("cl")
		if IsNull(vCargoLocation) then
			vCargoLocation=""
		end if
		vContainerLocation=rs("container_location")
		vDestination=rs("destination")
		vFreeDate=rs("last_free_date")
		if IsNull(vFreeDate) then
			vFreeDate=" "
		end if
		vGODate=rs("go_date")
		vITNumber=rs("itno")
		if IsNull(vITNumber) then
			vITNumber=" "
		end if
		vITDate=rs("itdate")
		if IsNull(vITDate) then
			vITDate=" "
		end if
		vITEntryPort=rs("itentryport")
		if IsNull(vITEntryPort) then
			vITEntryPort=" "
		end if
		vDesc1=rs("desc1")
		vDesc2=rs("desc2")
		vDesc3=rs("desc3")
		vDesc4=rs("desc4")
		vDesc5=rs("desc5")
		vRemarks=rs("remarks")
	end if
	rs.close
end if
response.buffer = True

'///////////////////////////////// by ig 2006.6.19
If Trim(vMAWB) =  Trim(vHAWB) Then
	vHAWB = "N/A"
End if

DIM oFile
oFile = Server.MapPath("../template")

Set PDF = GetNewPDFObject()
r = PDF.OpenOutputFile("MEMORY")

'/////////////////////////////////////////////////////////////////////////
Set fso = CreateObject("Scripting.FileSystemObject")
Dim CustomerForm
CustomerForm=oFile & "/Customer/" & "AuthorityMakeEntry" & elt_account_number & ".pdf"

If fso.FileExists(CustomerForm) Then
'// Customer has a specific form
	r = PDF.OpenInputFile(CustomerForm)

Else
'// Normal Form
	r = PDF.OpenInputFile(oFile+"/AuthorityMakeEntry.pdf")
End If
Set fso = nothing
'////////////////////////////////////////////////////////////////////////

'// On Error Resume Next:
PDF.SetFormFieldData "AgentName",vAgentName,0
PDF.SetFormFieldData "AgentInfo",vAgentInfo,0
PDF.SetFormFieldData "ExportAgentName",vExportAgentName,0
PDF.SetFormFieldData "ShipperName",Left(vShipperInfo,InStr(vShipperInfo,chr(13))),0
PDF.SetFormFieldData "ShipperInfo",Mid(vShipperInfo,InStr(vShipperInfo,chr(13))+1),0
PDF.SetFormFieldData "ConsigneeName",Left(vConsigneeInfo,InStr(vConsigneeInfo,chr(13))),0
PDF.SetFormFieldData "ConsigneeInfo",Mid(vConsigneeInfo,InStr(vConsigneeInfo,chr(13))+1),0
PDF.SetFormFieldData "NotifyName",Left(vNotifyInfo,InStr(vNotifyInfo,chr(13))),0
PDF.SetFormFieldData "NotifyInfo",Mid(vNotifyInfo,InStr(vNotifyInfo,chr(13))+1),0
PDF.SetFormFieldData "BrokerName",Left(vBrokerInfo,InStr(vBrokerInfo,chr(13))),0
PDF.SetFormFieldData "BrokerInfo",Mid(vBrokerInfo,InStr(vBrokerInfo,chr(13))+1),0
PDF.SetFormFieldData "FileNo",vFileNo,0
PDF.SetFormFieldData "FLTNo",vFLTNo,0
PDF.SetFormFieldData "Date",vProcessDT,0
PDF.SetFormFieldData "MAWB",vMAWB,0
PDF.SetFormFieldData "SubHAWB",vSubHAWB,0
PDF.SetFormFieldData "PreparedBy",vPreparedBy,0
'PDF.SetFormFieldData "SubMAWB",vSubMAWB,0
'PDF.SetFormFieldData "SubMAWB2",vSubMAWB2,0
PDF.SetFormFieldData "HAWB",vHAWB,0
PDF.SetFormFieldData "CustomerRef",vCustomerRef,0
PDF.SetFormFieldData "ArrPort",vArrPort,0
PDF.SetFormFieldData "DepPort",vDepPort,0
PDF.SetFormFieldData "ETD",vETD,0
PDF.SetFormFieldData "ETA",vETA,0
'PDF.SetFormFieldData "Vessel",vVessel,0
PDF.SetFormFieldData "DeliveryPlace",vDeliveryPlace,0
PDF.SetFormFieldData "Destination",vDestination,0
PDF.SetFormFieldData "ETD2",vETD2,0
PDF.SetFormFieldData "ETA2",vETA2,0
PDF.SetFormFieldData "CargoLocation",vCargoLocation,0
PDF.SetFormFieldData "ContainerLocation",vContainerLocation,0
PDF.SetFormFieldData "FreeDate",vFreeDate,0
PDF.SetFormFieldData "GODate",vGODate,0
PDF.SetFormFieldData "ITNumber",vITNumber,0
PDF.SetFormFieldData "ITDate",vITDate,0
PDF.SetFormFieldData "ITEntryPort",vITEntryPort,0
PDF.SetFormFieldData "Desc1",vDesc1,0
PDF.SetFormFieldData "Desc2",vDesc2,0
PDF.SetFormFieldData "Desc3",vDesc3,0
PDF.SetFormFieldData "Desc4",vDesc4,0
PDF.SetFormFieldData "Desc5",vDesc5,0
PDF.SetFormFieldData "Remarks",vRemarks,0

'// Last Modifed by Joon on Feb/08/2007 /////////////////////////////////////////////////
'// Added by Joon on Jan/29/2007 - KAS requested ////////////////////////////////////////
If Left(elt_account_number,4) = "2001" Then
    Dim lastLine,lastLineName

    If checkBlank(vBrokerInfo,"") = "" Then
        lastLineName = "the consignee / the borker"
    Else
        If InStr(vBrokerInfo,chr(13)) Then
	    lastLineName = Left(vBrokerInfo,InStr(vBrokerInfo,chr(13))-1)
        Else
	    lastLineName = vBrokerInfo
        End If
    End If

    lastLine = "We, " & vAgentName & ", the consignee of the above mentioned airway bill covering " _
        & "merchandise for various ultimate consignees, hereby authorize " _ 
        & lastLineName & " to make customs entry for " _
        & "the above described goods. Please be advised that any storage charges must be " _
        & "collected from the ultimate consignee or broker."
    PDF.SetFormFieldData "lastLine",lastLine,0
End If
'/////////////////////////////////////////////////////////////////////////////////////////

R = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
R=PDF.CopyForm(0, 0)
PDF.CloseOutputFile

response.expires = 0
response.clear
response.ContentType = "application/pdf"
response.AddHeader "Content-Type", "application/pdf"
response.AddHeader "Content-Disposition", "attachment; filename=AUTH" & Session.SessionID & ".pdf"
WritePDFBinary(PDF)
set PDF=nothing

%>
