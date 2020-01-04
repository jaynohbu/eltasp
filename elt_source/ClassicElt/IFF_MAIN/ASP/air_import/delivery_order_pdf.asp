<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
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

    Call show_pdf_result

    Sub show_pdf_result
        
        Dim reader,fso,CustomerForm,bridge,oFile,PDF
        
        oFile = Server.MapPath("../template")
        Set PDF = GetNewPDFObject()
        reader = PDF.OpenOutputFile("MEMORY")

        Set fso = CreateObject("Scripting.FileSystemObject")
        CustomerForm=oFile & "/Customer/" & "delivery_order_" & elt_account_number & ".pdf"

        If fso.FileExists(CustomerForm) Then
            reader = PDF.OpenInputFile(CustomerForm)
        Else
            reader = PDF.OpenInputFile(oFile & "/delivery_order.pdf")
        End If

        Call get_param_values(PDF)
        reader = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
        reader = PDF.CopyForm(0, 0)
        PDF.CloseOutputFile
        
        Response.Clear
        Response.Expires = 0
        Response.ContentType = "application/pdf"
        Response.AddHeader "Content-Type", "application/pdf"
        Response.AddHeader "Content-Disposition", "attachment; filename=DO" & Session.SessionID & ".pdf"
        WritePDFBinary(PDF)

        Set fso = Nothing
        Set PDF = Nothing
        Set reader = Nothing
        Set bridge = Nothing
        
    End Sub
    
    Sub get_param_values(PDF)
        
        'On Error Resume Next:
        Dim cargo_code
        cargo_code = checkBlank(Request.Form("lstCargoLocation").Item,"")
        If cargo_code <> "" Then
            cargo_code = cargo_code & "-" & GetFreightName(cargo_code,elt_account_number)
        End If
        
        PDF.SetFormFieldData "route", Request.Form("txtRoute").Item & "", 0
        PDF.SetFormFieldData "memberName", GetAgentName(elt_account_number) & "", 0
        PDF.SetFormFieldData "member", GetAgentAddress(elt_account_number) & "", 0
        
        PDF.SetFormFieldData "pickup", Request.Form("lstPickupName").Item & "", 0
        PDF.SetFormFieldData "pickupLocation", Request.Form("txtPickupInfo").Item & "", 0
        
        PDF.SetFormFieldData "date", Request.Form("txtUpdateDate").Item & "", 0
        PDF.SetFormFieldData "ourref", Request.Form("txtRefNoOur").Item & "", 0
        PDF.SetFormFieldData "carrier", Request.Form("lstCarrierName").Item & "", 0
        PDF.SetFormFieldData "location", cargo_code & "", 0

        PDF.SetFormFieldData "arrDate", Request.Form("txtArrDate").Item & "", 0
        
        PDF.SetFormFieldData "originPort", Request.Form("lstDepPort"), 0
        PDF.SetFormFieldData "destinationPort", Request.Form("lstArrPort"), 0
        
        PDF.SetFormFieldData "master", Request.Form("txtMAWB").Item & "", 0
        PDF.SetFormFieldData "arrdept", Request.Form("txtArrDate").Item & "", 0
        PDF.SetFormFieldData "freetime", Request.Form("txtFreeDate").Item & "", 0
        PDF.SetFormFieldData "trucker", Request.Form("lstTruckerName").Item & "", 0
        PDF.SetFormFieldData "truckerinfo", Request.Form("txtTruckerInfo").Item & "", 0
        PDF.SetFormFieldData "house", Request.Form("txtHAWB").Item & "", 0
        PDF.SetFormFieldData "entrynum",  Request.Form("txtEntryBilling").Item & "", 0
        PDF.SetFormFieldData "cusref", Request.Form("txtCustomerRef").Item & "", 0
        PDF.SetFormFieldData "consignee", Request.Form("txtConsigneeInfo").Item & "", 0
        PDF.SetFormFieldData "importer", Request.Form("txtImporterInfo").Item & "", 0
        PDF.SetFormFieldData "pieces", Request.Form("txtPieces").Item & "", 0
        PDF.SetFormFieldData "desc", Request.Form("txtDesc3").Item & "", 0
        PDF.SetFormFieldData "weight", ConvertAnyValue(Request.Form("txtGrossWt").Item,"Amount",0) & " " & Request.Form("lstScale1").Item, 0
        PDF.SetFormFieldData "dimension", ConvertAnyValue(Request.Form("txtDimension").Item,"Amount",0) & " " & Request.Form("lstDimScale").Item, 0
        PDF.SetFormFieldData "inland", ConvertAnyValue(Request.Form("txtInlandCharge").Item,"Amount",0), 0
        PDF.SetFormFieldData "route", Request.Form("txtRoute").Item & "", 0
        PDF.SetFormFieldData "handling", Request.Form("txtHandling").Item & "", 0
        PDF.SetFormFieldData "attention", Request.Form("txtAttention").Item & "", 0
        PDF.SetFormFieldData "employee", Request.Form("txtEmployee").Item & "", 0
        PDF.SetFormFieldData "subhouse", Request.Form("txtSubHAWB").Item & "", 0
        PDF.SetFormFieldData "contact", "Contact: " & Request.Form("txtContact").Item, 0
        
        If Request.Form("hInlandChargeType") = "P" Then
            PDF.SetFormFieldData "prepaid", "X", 0
        Elseif Request.Form("hInlandChargeType") = "C" Then
            PDF.SetFormFieldData "collect", "X", 0
        Else
        End If
    End Sub

%>