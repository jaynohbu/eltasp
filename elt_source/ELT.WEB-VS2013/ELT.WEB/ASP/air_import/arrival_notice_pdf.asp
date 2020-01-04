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
Dim doInvoice
Dim vInvoiceNo

doInvoice=Request.QueryString("doInvoice")
vInvoiceNo=Request.QueryString("invoice_no")
iType=Request.QueryString("iType")
vHAWB=Request.QueryString("HAWB")
vMAWB=Request.QueryString("MAWB")

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

'if Not vHAWB="" then '------------11/30/06
    if true  then
	   ' SQL="select a.it_number as itno,a.it_date as itdate,a.it_entry_port as itentryport,a.cargo_location as cl,a.sec as sec,a.*,a.process_dt as process_dt_h,a.mawb_num as mawb_num,b.* from import_hawb a,import_mawb b where a.elt_account_number=b.elt_account_number and a.elt_account_number=" & elt_account_number & " and a.iType=b.iType and a.iType='" & iType & "' and a.mawb_num=b.mawb_num and a.hawb_num='" & vHAWB & "' and a.sec=b.sec order by sec desc"
	   if  vInvoiceNo="" then  
	    SQL="select a.it_number as itno,a.it_date as itdate,a.it_entry_port as itentryport,a.cargo_location as cl,a.sec as "&_ 
		" sec,a.*,a.process_dt as process_dt_h,a.mawb_num as mawb_num,isnull(a.dep_port,'') as dep_port_h,isnull(a.arr_port,'') as "&_ 
		" arr_port_h,b.*,a.eta as eta_h,a.etd as etd_h from import_hawb a,import_mawb b where a.elt_account_number=b.elt_account_number and a.elt_account_number="&_ 
		elt_account_number & " and a.mawb_num=N'"&vMAWB&"'"& " and a.iType=b.iType and a.iType='" & iType & "' and "&_	
		" a.mawb_num=b.mawb_num and a.hawb_num=N'" & vHAWB & "' and a.sec=b.sec order by sec desc"
	   else
	        SQL="select a.it_number as itno,a.it_date as itdate,a.it_entry_port as itentryport,a.cargo_location as cl,a.sec as"&_
		" sec,a.*,a.process_dt as process_dt_h,a.mawb_num as mawb_num,isnull(a.dep_port,'') as dep_port_h,isnull(a.arr_port,'') as"&_ 
		" arr_port_h,b.*,a.eta as eta_h,a.etd as etd_h from import_hawb a,import_mawb b where a.elt_account_number=b.elt_account_number and a.elt_account_number=" &_
        elt_account_number &" and a.mawb_num=N'"&vMAWB&"'"& " and a.iType=b.iType and a.iType='" & iType & "' and a.mawb_num=b.mawb_num and "&_ 
        " a.hawb_num=N'" & vHAWB & "' and a.sec=b.sec and a.invoice_no="&vInvoiceNo
	   end if 
	    rs.Open SQL, eltConn, , , adCmdText


	if Not rs.EOF then
		vHAWB=rs("hawb_num")
		InvoiceNo=rs("invoice_no")
		if IsNull(InvoiceNo) Then
			InvoiceNo=0
		else
			InvoiceNo=cLng(InvoiceNo)
		end if
		vExportAgentName=rs("export_agent_name")
		vShipperInfo=rs("shipper_info")
		vConsigneeInfo=rs("consignee_info")
		vNotifyInfo=rs("notify_info")
		vFileNo=rs("file_no")
		vProcessDT=rs("process_dt_h")
		vMAWB=rs("mawb_num")
		vPreparedBy=rs("prepared_by")
		
		vSubHAWB=rs("igsub_hawb")
		if Isnull(rs("igsub_hawb")) = true then
			vSubHAWB=""
		end if
		
'		vSubMAWB2=rs("sub_mawb2")
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
		vVessel=rs("flt_no")
		if IsNull(vVessel) then
			vVessel=""
		end if
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
	if Not InvoiceNo=0 then
		SQL= "select * from invoice_charge_item where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo &" order by item_id"
		rs.Open SQL, eltConn, , , adCmdText
		tIndex=0
		vTotalAmount=0
		Do While Not rs.EOF
			aDesc(tIndex)=rs("item_desc")
			aAmount(tIndex)=rs("charge_amount")
			vTotalAmount=vTotalAmount+cdbl(aAmount(tIndex))
			rs.MoveNext
			tIndex=tIndex+1
		Loop
		rs.Close
		NoItem=tIndex
	end if
end If

'///////////////////////////////// by ig 2006.6.19
If Trim(vMAWB) =  Trim(vHAWB) Then
	vHAWB = "N/A"
End if
response.buffer = True

DIM oFile
oFile = Server.MapPath("../template")

Set PDF = GetNewPDFObject()

r = PDF.OpenOutputFile("MEMORY")

'/////////////////////////////////////////////////////////////////////////
Set fso = CreateObject("Scripting.FileSystemObject")
Dim CustomerForm
CustomerForm=oFile & "/Customer/" & "arrival_notice" & elt_account_number & ".pdf"

If fso.FileExists(CustomerForm) Then
'// Customer has a specific invoice form
	r = PDF.OpenInputFile(CustomerForm)

Else
'// Normal Form
	r = PDF.OpenInputFile(oFile+"/arrival_notice.pdf")
End If
Set fso = nothing
'////////////////////////////////////////////////////////////////////////

On Error Resume Next
PDF.SetFormFieldData "AgentName",vAgentName,0
PDF.SetFormFieldData "AgentInfo",vAgentInfo,0
PDF.SetFormFieldData "ExportAgentName",vExportAgentName,0
PDF.SetFormFieldData "ShipperName",Left(vShipperInfo,InStr(vShipperInfo,chr(13))),0
PDF.SetFormFieldData "ShipperInfo",Mid(vShipperInfo,InStr(vShipperInfo,chr(13))+1),0
PDF.SetFormFieldData "ConsigneeName",Left(vConsigneeInfo,InStr(vConsigneeInfo,chr(13))),0
PDF.SetFormFieldData "ConsigneeInfo",Mid(vConsigneeInfo,InStr(vConsigneeInfo,chr(13))+1),0
PDF.SetFormFieldData "NotifyName",Left(vNotifyInfo,InStr(vNotifyInfo,chr(13))),0
PDF.SetFormFieldData "NotifyInfo",Mid(vNotifyInfo,InStr(vNotifyInfo,chr(13))+1),0

If InStr(vBrokerInfo,chr(13)) > 0 Then
    PDF.SetFormFieldData "BrokerName",Left(vBrokerInfo,InStr(vBrokerInfo,chr(13))),0
    PDF.SetFormFieldData "BrokerInfo",Mid(vBrokerInfo,InStr(vBrokerInfo,chr(13))+1),0
Else
    PDF.SetFormFieldData "BrokerName",vBrokerInfo,0
End If

PDF.SetFormFieldData "FileNo",vFileNo,0
PDF.SetFormFieldData "Date",vProcessDT,0
PDF.SetFormFieldData "MAWB",vMAWB,0
PDF.SetFormFieldData "PreparedBy",vPreparedBy,0
PDF.SetFormFieldData "SubHAWB",vSubHAWB,0
'PDF.SetFormFieldData "SubMAWB2",vSubMAWB2,0
PDF.SetFormFieldData "HAWB",vHAWB,0
PDF.SetFormFieldData "CustomerRef",vCustomerRef,0
PDF.SetFormFieldData "ArrPort",vArrPort,0
PDF.SetFormFieldData "DepPort",vDepPort,0
PDF.SetFormFieldData "ETD",vETD,0
PDF.SetFormFieldData "ETA",vETA,0
PDF.SetFormFieldData "Vessel",vVessel,0
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
if Not doInvoice="no" then 
PDF.SetFormFieldData "InvoiceNo",InvoiceNo,0
end if 
dim FI, AN
FI="FREIGHT INVOICE"
AN="ARRIVAL NOTICE"

Dim j
j=1
If Not doInvoice = "no" then 
    for i=0 to NoItem-1
        if cInt(aAmount(i))<> 0 then 
	        PDF.SetFormFieldData "Item" & j, aDesc(i), 0
	        PDF.SetFormFieldData "Collect" & j, FormatNumber(aAmount(i),2), 0
	        j = j + 1
	    end if 
    next
    PDF.SetFormFieldData "TotalCollect",FormatNumber(vTotalAmount,2),0
   PDF.SetFormFieldData "FI_TITLE",FI,0
End if 

PDF.SetFormFieldData "AN_TITLE",AN,0

R = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
R=PDF.CopyForm(0, 0)
PDF.CloseOutputFile

response.expires = 0
response.clear
response.ContentType = "application/pdf"
response.AddHeader "Content-Type", "application/pdf"
response.AddHeader "Content-Disposition", "attachment; filename=AN" & Session.SessionID & ".pdf"
WritePDFBinary(PDF)
set PDF=nothing

%>
