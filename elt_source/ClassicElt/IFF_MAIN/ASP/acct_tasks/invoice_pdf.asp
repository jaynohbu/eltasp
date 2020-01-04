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

Dim awb,vMAWB,vHAWB,vAgent,vMasterAgent,vOrgAcct
Dim Save,NewInvoice,EditInvoice,AddItem
Dim InvoiceNo,InvoiceDate,RefNo,InvoiceType,vInvoice_prefix,RefNo_Our
Dim CustomerInfo,Customer,CustomerInfoTelFax
Dim OriginDest,CustomerNumber,EntryDate,Carrier,ArrivalDept
Dim OriginPort,DestPort,Airline
Dim TotalPieces,TotalGrossWeight,Description
Dim NoItem,aItemNo(400),aItemName(400),aDesc(400),aRefNo(400),aAmount(400),aCost(400),aRealCost(400)
Dim aAR(400),aRevenue(400),aExpense(400)
Dim aVendor(400)
Dim aAW(400),aShare(400)
Dim SubTotal,SaleTax,AgentProfit,TotalAmount,AR
Dim qOrgInfo(256),qOrgName(256),qOrgAcct(256)
Dim vOrgInfo,CustomerName

'// by iMoon I/V Statement
Dim v_iv_statement

Dim rs, SQL
Set rs = Server.CreateObject("ADODB.Recordset")
Set rs1 = Server.CreateObject("ADODB.Recordset")
InvoiceNo=Request.QueryString("InvoiceNo")
if Not InvoiceNo="" then
	SQL= "select dba_name,business_address,business_city,business_state,business_zip,business_country,business_phone,business_fax,                 isnull(iv_statement,'') as iv_statement from agent where elt_account_number = " & elt_account_number
	rs.Open SQL, eltConn, , , adCmdText	
	If Not rs.EOF Then
		vOrgInfo1=rs("dba_name")
		vOrgInfo2=rs("business_address")
		vOrgInfo2=vOrgInfo2 & chr(13) & rs("business_city") & "," & rs("business_state") & " " & rs("business_zip")
		vOrgInfo2=vOrgInfo2 & chr(13) & rs("business_country")
		vTelFax="Tel: " & rs("business_phone") & "    " & "Fax: " & rs("business_fax")
		v_iv_statement=rs("iv_statement")
	End If
	rs.Close
	SQL= "select * from Invoice where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo
	rs.Open SQL, eltConn, , , adCmdText
	If Not rs.EOF Then
		InvoiceDate=rs("Invoice_Date")
		vTerm=cInt(rs("term_curr"))
		if vTerm>0 then
			InvoiceDueDate=InvoiceDate+vTerm
		else
			InvoiceDueDate=InvoiceDate
		end if
		RefNo=rs("ref_no")
		if IsnUll(RefNo) then RefNo=""
		RefNo_Our=rs("ref_no_Our")
		if IsnUll(RefNo_Our) then RefNo_Our=""
		orgNo=rs("customer_number")
		CustomerInfo=checkBlank(rs("Customer_Info"),"")
		CustomerName = rs("Customer_Name")
'//////////////////////////////////////////////////////////////////////////////////////////////////
'//    	Modified By Joon On Dec-8-2006 Uncomment following if neccessary

		CustomerInfo = Replace(UCASE(CustomerInfo), "UNITED STATES", "")
	
		If InStr(UCASE(CustomerInfo), "TEL:") > 0 Then
		    CustomerInfoTelFax = Right(CustomerInfo, Len(CustomerInfo)-InStr(UCASE(CustomerInfo), "TEL:")+1)
		    CustomerInfo = Left(CustomerInfo, InStr(UCASE(CustomerInfo), "TEL:")-1)
		Else
	        CustomerInfoTelFax = GetBusinessTelFax(orgNo)
		End if
		
'//     CustomerInfo = GetBusinessInfo(orgNo)
'//////////////////////////////////////////////////////////////////////////////////////////////////

		TotalPieces=rs("Total_Pieces")


		If Not rs("Total_Gross_Weight") = "" Then
			TotalGrossWeight=rs("Total_Gross_Weight")
		Else
			TotalGrossWeight=""		
		End If
		
		If Not rs("Total_Charge_Weight") = "" Then
			TotalChargeWeight=rs("Total_Charge_Weight")
		Else
			TotalChargeWeight=""		
		End If
		
		If TotalGrossWeight = ""  Then
		   TotalGrossWeight = TotalChargeWeight
           TotalChargeWeight = ""
		End if

		Description=rs("Description")
		if IsNull(Description) then Description=""
		Origin=rs("Origin")
		if IsNull(Origin) then Origin=""
		Dest=rs("Dest")
		if IsNull(Dest) then Dest=""
		OrgAcct=rs("Customer_Number")
		Customer=rs("Customer_Name")
		if IsNull(Customer) then Customer=""
		Shipper=rs("shipper")
		if ISNULL(Shipper) then Shipper=""
		Consignee=rs("consignee")
		if IsNULL(Consignee) then Consignee=""
		EntryNo=rs("Entry_No")
		if IsNull(EntryNo) then EntryNo=""
		EntryDate=rs("Entry_Date")
		if IsNull(EntryDate) then EntryDate=""
		Carrier=rs("Carrier")
		if IsNull(Carrier) then Carrier=""
		ArrivalDept=rs("Arrival_Dept")
		if IsNull(ArrivalDept) then ArrivalDept=""
		MAWB=rs("MAWB_NUM")
		if IsNull(MAWB) then MAWB=""
		HAWB=rs("HAWB_NUM")
		if IsNull(HAWB) then HAWB=""
		SubTotal=rs("SubTotal")
		SaleTax=rs("Sale_Tax")
		AgentProfit=rs("Agent_Profit")
		if IsNull(AgentProfit) then
			AgentProfit=0
		else
			AgentProfit=cDbl(AgentProfit)
		end if
		TotalAmount=rs("amount_charged")
		TotalCost=rs("total_cost")
		Remarks=rs("remarks")
		if IsNull(Remarks) then Remarks=""
	End If
	rs.Close
	SQL= "select * from invoice_charge_item where elt_account_number = " & elt_account_number & " and invoice_no=" & InvoiceNo 
	SQL= SQL & " order by item_id" 
	rs.Open SQL, eltConn, , , adCmdText
	tIndex=0
	total=0
	Do While Not rs.EOF
		aDesc(tIndex)=rs("item_desc")
		aAmount(tIndex)=rs("charge_amount")
		rs.MoveNext
		total=total+cDbl(aAmount(tIndex))
		tIndex=tIndex+1
	Loop
	rs.Close
	total=total-AgentProfit
end if

'///////////////////////////// by ig_moon

if HAWB = "0" then
	HAWB = " "		
end if

if Not InvoiceNo="" then
	SQL= "select * from user_profile where elt_account_number = " & elt_account_number
	rs.Open SQL, eltConn, , , adCmdText	

	If Not rs.EOF Then
		vInvoice_prefix=rs("invoice_prefix")
	End If
	rs.Close
end if


Set rs=Nothing
Set rs1=Nothing
response.buffer = True

DIM oFile
oFile = Server.MapPath("../template")

Set PDF = GetNewPDFObject()
r = PDF.OpenOutputFile("MEMORY")

Set fso = CreateObject("Scripting.FileSystemObject")
Dim CustomerForm
CustomerForm=oFile & "/Customer/" & "Invoice" & elt_account_number & ".pdf"

If fso.FileExists(CustomerForm) Then
	r = PDF.OpenInputFile(CustomerForm)
Else
	r = PDF.OpenInputFile(oFile+"/invoice.pdf")
End If

Set fso = nothing

Dim Pages, LineLimit, i, j, k
LineLimit = 25
Pages = Int(tIndex / LineLimit) + 1
i = 0

    r = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf", 1)
    
    For j = 1 To Pages
    k = 0
    '////////////////////////////////////////////////////////////////////////
    On Error Resume Next:
    PDF.SetFormFieldData "From1",vOrgInfo1,0
    PDF.SetFormFieldData "From2",vOrgInfo2,0
    PDF.SetFormFieldData "TelFax",vTelFax,0

    if not vInvoice_prefix = "" then
    PDF.SetFormFieldData "InvoiceNo",vInvoice_prefix & "-" & InvoiceNo,0
    else
    PDF.SetFormFieldData "InvoiceNo", InvoiceNo,0
    end if

    PDF.SetFormFieldData "InvoiceDate",InvoiceDate,0
    PDF.SetFormFieldData "InvoiceDueDate",InvoiceDueDate,0
    PDF.SetFormFieldData "RefNo",RefNo,0
    PDF.SetFormFieldData "fileNo",RefNo_Our,0
    PDF.SetFormFieldData "CustomerName", UCase(CustomerName) & "",0
    PDF.SetFormFieldData "CustomerInfo",Mid(CustomerInfo,InStr(CustomerInfo,chr(13))+1) & "",0
    PDF.SetFormFieldData "CustomerTelFax", CustomerInfoTelFax, 0

    PDF.SetFormFieldData "TotalPieces",TotalPieces,0
    PDF.SetFormFieldData "TotalGrossWeight",TotalGrossWeight,0
    PDF.SetFormFieldData "TotalChargeWeight",TotalChargeWeight,0
    PDF.SetFormFieldData "Desc",Description,0
    PDF.SetFormFieldData "Shipper",Shipper,0
    PDF.SetFormFieldData "Consignee",Consignee,0
    PDF.SetFormFieldData "Origin",Origin,0
    PDF.SetFormFieldData "Dest",Dest,0
    PDF.SetFormFieldData "OrgAcct",OrgAcct,0
    PDF.SetFormFieldData "EntryNo",EntryNo,0
    PDF.SetFormFieldData "EntryDate",EntryDate,0
    PDF.SetFormFieldData "Carrier",Carrier,0
    PDF.SetFormFieldData "ArrivalDept",ArrivalDept,0
    PDF.SetFormFieldData "MAWB",MAWB,0
    PDF.SetFormFieldData "HAWB",HAWB,0
    PDF.SetFormFieldData "Remarks",Remarks,0
    PDF.SetFormFieldData "DEFAULT_STATEMENT", v_iv_statement, 0
    PDF.SetFormFieldData "PageNumber", j & "/" & Pages, 0
    
    Do While (i < tIndex And i < (j * LineLimit))
	    PDF.SetFormFieldData "Desc" & k + 1, aDesc(i),0
	    PDF.SetFormFieldData "Amount" & k + 1, FormatNumber(aAmount(i), 2),0
	    i = i + 1
	    k = k + 1
    Loop
    
    If i = tIndex Then
        '// If FormatNumber(AgentProfit,2) <> 0 Then
		If ConvertAnyValue(AgentProfit, "Double", 0) <> 0 Then
            If i < (j * LineLimit) Then
                PDF.SetFormFieldData "Desc" & k + 1, "AGENT PROFIT", 0
                PDF.SetFormFieldData "Amount" & k + 1, -1 * AgentProfit, 0
                PDF.SetFormFieldData "Total", FormatNumber(Total,2), 0
            Else
                Pages = Pages + 1
            End If
        Else
            PDF.SetFormFieldData "Total", FormatNumber(Total,2), 0
        End If
    End If

    r = PDF.CopyForm(0, 0)
    PDF.ResetFormFields
    '////////////////////////////////////////////////////////////////////////
    Next
    
PDF.CloseOutputFile

response.expires = 0
response.clear
response.ContentType = "application/pdf"
response.AddHeader "Content-Type", "application/pdf"
response.AddHeader "Content-Disposition", "attachment;filename=INV" & Session.SessionID & ".pdf"
WritePDFBinary(PDF)

eltConn.Close
set PDF=nothing
Set eltConn=Nothing
Response.End()

 
%>
