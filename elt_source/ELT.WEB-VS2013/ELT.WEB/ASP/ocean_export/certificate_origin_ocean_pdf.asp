<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
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
    Call show_pdf_result

    Sub show_pdf_result
        
        Dim reader,fso,CustomerForm,bridge,oFile,PDF
        
        oFile = Server.MapPath("../template")
        Set PDF =GetNewPDFObject()
        reader = PDF.OpenOutputFile("MEMORY")

        Set fso = CreateObject("Scripting.FileSystemObject")
        CustomerForm=oFile & "/Customer/" & "certificate_origin_" & elt_account_number & ".pdf"

        If fso.FileExists(CustomerForm) Then
            reader = PDF.OpenInputFile(CustomerForm)
        Else
            reader = PDF.OpenInputFile(oFile & "/certificate_origin.pdf")
        End If

        Call get_param_values(PDF)
        '// reader = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
        reader = PDF.CopyForm(0, 0)
        PDF.CloseOutputFile
            
        Response.Expires = 0
        Response.Clear
        Response.ContentType = "application/pdf"
        Response.AddHeader "Content-Type", "application/pdf"
        Response.AddHeader "Content-Disposition", "attachment; filename=CO" & Session.SessionID & ".pdf"
        WritePDFBinary(PDF)

        Set fso = Nothing
        Set PDF = Nothing
        Set reader = Nothing

    End Sub
    
    Sub get_param_values(PDF)
        
        PDF.SetFormFieldData "shipper", Request.Form("txtShipperInfo").Item & "", 0
	    PDF.SetFormFieldData "consignee", Request.Form("txtConsigneeInfo").Item & "", 0
	    PDF.SetFormFieldData "agent", Request.Form("txtAgentInfo").Item & "", 0
	    PDF.SetFormFieldData "notify", Request.Form("txtNotifyInfo").Item & "", 0
	    
        PDF.SetFormFieldData "awbnum", checkBlank(Request.Form("txtHBOLNum").Item,Request.Form("txtMBOLNum").Item) & "", 0

        PDF.SetFormFieldData "docnum", Request.Form("txtBookingNum").Item & "", 0
	    PDF.SetFormFieldData "exportref", Request.Form("txtExportRef").Item & "", 0
	    PDF.SetFormFieldData "state", Request.Form("txtUsState").Item & "", 0
	    PDF.SetFormFieldData "exportInstr", Request.Form("txtExportInstr").Item & "", 0
	    PDF.SetFormFieldData "precarriage", Request.Form("txtPreCarriage").Item & "", 0
	    PDF.SetFormFieldData "receiptplace", Request.Form("txtPreReceiptPlace").Item & "", 0
	    PDF.SetFormFieldData "carrier", Request.Form("txtExportCarrier").Item & "", 0
	    PDF.SetFormFieldData "loadingport", Request.Form("txtLoadingPort").Item & "", 0
	    PDF.SetFormFieldData "loadingtermial", Request.Form("txtLoadingPier").Item & "", 0
	    PDF.SetFormFieldData "unloadingport", Request.Form("txtUnloadingPort").Item & "", 0
	    PDF.SetFormFieldData "deliveryplace", Request.Form("txtDeliveryPlace").Item & "", 0
	    PDF.SetFormFieldData "movetype", Request.Form("txtMoveType").Item & "", 0
        
        If Request.Form("chkContainerized").Item = "Y" Then
		    PDF.SetFormFieldData "conYes", "X", 0
	    Else
		    PDF.SetFormFieldData "conNo", "X", 0
	    End If

        Dim i
        i = 1
        PDF.SetFormFieldData "mark"&i, Request.Form("txtDesc1").Item & "", 0
        PDF.SetFormFieldData "num"&i, Request.Form("txtDesc2").Item & "", 0
        PDF.SetFormFieldData "item"&i, Request.Form("txtDesc3").Item & "", 0
        PDF.SetFormFieldData "weight"&i, Request.Form("txtGrossWeight").Item & "", 0
        PDF.SetFormFieldData "scale1"&i, Request.Form("lstWeightScale").Item & "", 0
        PDF.SetFormFieldData "measure"&i, Request.Form("txtMeasurement").Item & "", 0
        PDF.SetFormFieldData "scale2"&i, Request.Form("lstMeasurementScale").Item & "", 0
        
        PDF.SetFormFieldData "ffName", Request.Form("txtFFName").Item & "", 0
        PDF.SetFormFieldData "ffCity", Request.Form("txtFFCity").Item & "", 0
        PDF.SetFormFieldData "ffCounty", Request.Form("lstFFCounty").Item & "", 0
        PDF.SetFormFieldData "prepareBy", Request.Form("txtPrepareBy").Item & "", 0
	    PDF.SetFormFieldData "originCountry", Request.Form("txtOriginCountry").Item & "", 0
        PDF.SetFormFieldData "createdDate", Request.Form("txtCreatedDate").Item & "", 0
        PDF.SetFormFieldData "swornDate", Request.Form("txtSwornDate").Item & "", 0
        PDF.SetFormFieldData "stateCopy", Request.Form("txtOriginState").Item & "", 0
        PDF.SetFormFieldData "country", GetSQLResult("SELECT b.country_name FROM agent a LEFT OUTER JOIN all_country_code b ON (ISNULL(a.country_code,'US')=b.country_code) WHERE a.elt_account_number=" & elt_account_number, Null) & "", 0
    End Sub

%>