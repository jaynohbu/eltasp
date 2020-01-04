<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/PDFManager.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_Util_fun.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_data_manager.inc" -->
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
        CustomerForm=oFile & "/Customer/" & "booking_confirm_" & elt_account_number & ".pdf"

        If fso.FileExists(CustomerForm) Then
            reader = PDF.OpenInputFile(CustomerForm)
        Else
            reader = PDF.OpenInputFile(oFile & "/booking_confirm.pdf")
        End If

        Call set_PDF_values(PDF)

        reader = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
        reader = PDF.CopyForm(0, 0)
        PDF.CloseOutputFile
            
        Response.Expires = 0
        Response.Clear
        Response.ContentType = "application/pdf"
        Response.AddHeader "Content-Type", "application/pdf"
        Response.AddHeader "Content-Disposition", "inline; filename=BC" & Session.SessionID & ".pdf"
        WritePDFBinary(PDF)

        Set fso = Nothing
        Set PDF = Nothing
        Set reader = Nothing

    End Sub
    
    Sub set_PDF_values(PDF)
        Dim dataObj, dataTable, SQL, rs
        
		SQL = "SELECT * FROM booking_confirm WHERE elt_account_number=" & elt_account_number _
			& " AND auto_uid=" & Request.QueryString("uid")
		
		Set rs = Server.CreateObject("ADODB.Recordset")
		Set dataObj = new DataManager
		dataObj.SetDataList(SQL)
        Set dataTable = dataObj.GetRowTable(0)

        PDF.SetFormFieldData "memberName", GetAgentName(elt_account_number) & "", 0
        PDF.SetFormFieldData "member", GetAgentAddress(elt_account_number) & "", 0
        PDF.SetFormFieldData "document_date", dataTable("document_date") & "", 0
		PDF.SetFormFieldData "bc_no", dataTable("bc_no") & "", 0
		PDF.SetFormFieldData "shipper_info", dataTable("shipper_info") & "", 0
		PDF.SetFormFieldData "export_reference", dataTable("export_reference") & "", 0
		PDF.SetFormFieldData "booking_no", dataTable("booking_no") & "", 0
		PDF.SetFormFieldData "place_of_receipt", dataTable("place_of_receipt") & "", 0
		PDF.SetFormFieldData "carrier_name", dataTable("carrier_name") & "", 0
		PDF.SetFormFieldData "carrier_no", dataTable("carrier_no") & "", 0
		PDF.SetFormFieldData "dep_port", GetPortInfo(dataTable("dep_port"), "port_desc") & "", 0
		PDF.SetFormFieldData "arr_port", GetPortInfo(dataTable("arr_port"), "port_desc") & "", 0
		PDF.SetFormFieldData "etd", dataTable("etd") & "", 0
		PDF.SetFormFieldData "eta", dataTable("eta") & "", 0
		PDF.SetFormFieldData "place_of_delivery", dataTable("place_of_delivery") & "", 0
		PDF.SetFormFieldData "move_type", dataTable("move_type") & "", 0
		PDF.SetFormFieldData "consignee_info", dataTable("deliver_to_info") & "", 0
		PDF.SetFormFieldData "dest_agent_info", dataTable("dest_agent_info") & "", 0
		PDF.SetFormFieldData "cut_off_date", dataTable("cut_off_date") & "", 0
		PDF.SetFormFieldData "dangerous", dataTable("dangerous") & "", 0
		
		if dataTable("quantity") <> "" Then
		    PDF.SetFormFieldData "quantity", dataTable("quantity") & dataTable("quantity_unit") & "", 0
		End If
		PDF.SetFormFieldData "item_desc", dataTable("item_desc") & "", 0
		If dataTable("weight") <> "" Then
		    PDF.SetFormFieldData "weight", dataTable("weight") & dataTable("weight_scale") & "", 0
		End If
		If dataTable("dimension") <> "" Then
		    PDF.SetFormFieldData "dimension", dataTable("dimension") & dataTable("dimension_scale") & "", 0
		End If
		PDF.SetFormFieldData "empty_container_pick_up_info", dataTable("empty_container_pick_up_info") & "", 0
		PDF.SetFormFieldData "remark", dataTable("remark") & "", 0

    End Sub

%>