<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE FILE="../include/PDFManager.inc" -->
<%
    Dim elt_account_number,user_id,vMAWB
	elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
	user_id = Request.Cookies("CurrentUserInfo")("user_id")
    vMAWB = Request.QueryString("MAWB").Item
    '// On Error Resume Next:
    
    Call show_pdf_result
    eltConn.Close
    Set eltConn = Nothing
    

    Sub show_pdf_result
        
        Dim reader,fso,CustomerForm,bridge,oFile,PDF
        
        oFile = Server.MapPath("../template")
        Set PDF = GetNewPDFObject()
        reader = PDF.OpenOutputFile("MEMORY")

        Set fso = CreateObject("Scripting.FileSystemObject")
        CustomerForm=oFile & "/Customer/" & "iac_" & elt_account_number & ".pdf"

        If fso.FileExists(CustomerForm) Then
            reader = PDF.OpenInputFile(CustomerForm)
            Call get_param_values(PDF)
        Else
            reader = PDF.OpenInputFile(oFile & "/iac_unknown.pdf")
            Call get_param_values(PDF)
            reader = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
        End If

        reader = PDF.CopyForm(0, 0)
        PDF.CloseOutputFile
            
        Response.Expires = 0
        Response.Clear
        Response.ContentType = "application/pdf"
        Response.AddHeader "Content-Type", "application/pdf"
        Response.AddHeader "Content-Disposition", "inline; filename=iac_unknown.pdf"
        WritePDFBinary(PDF)

        Set fso = Nothing
        Set PDF = Nothing
        Set reader = Nothing
        Set bridge = Nothing

    End Sub
    Sub get_param_values(PDF)
        
        Dim SQL,rs,rsFAA,FAANum,FAADate
        Set rs = Server.CreateObject("ADODB.Recordset")
        Set rsFAA = Server.CreateObject("ADODB.Recordset")
        SQL = "SELECT * FROM mawb_number a LEFT OUTER JOIN mawb_master b ON (a.elt_account_number=b.elt_account_number AND a.mawb_no = b.mawb_num) WHERE a.elt_account_number=" & elt_account_number & " AND a.mawb_no='" & vMAWB & "'"
        Set rs = eltConn.execute(SQL)
        If Not rs.EOF AND Not rs.BOF Then
            
            PDF.SetFormFieldData "PreparedBy", GetUserFLName(user_id) & "", 0
            PDF.SetFormFieldData "AgentName", GetAgentName(elt_account_number) & "", 0
            PDF.SetFormFieldData "AgentInfo", GetAgentAddress(elt_account_number) & "", 0
            PDF.SetFormFieldData "MAWB", checkBlank(rs("mawb_no").value,""), 0
            PDF.SetFormFieldData "Carrier", checkBlank(rs("Carrier_Desc").value,""), 0
            PDF.SetFormFieldData "Agent", GetAgentName(elt_account_number) & "", 0
            PDF.SetFormFieldData "Destination", checkBlank(rs("Dest_Airport").value,"") & "", 0
            PDF.SetFormFieldData "Country", checkBlank(rs("dest_country").value,""), 0
            PDF.SetFormFieldData "Date", Date() & "", 0
            
            SQL = "SELECT faa_approval_no, faa_approval_date FROM agent where elt_account_number=" & elt_account_number
            Set rsFAA = eltConn.execute(SQL)
            If Not rsFAA.EOF AND Not rsFAA.BOF Then
                FAANum = rsFAA("faa_approval_no").value
				FAADate = rsFAA("faa_approval_date").value
				
            End If
            rsFAA.Close()
            PDF.SetFormFieldData "FAA", checkBlank(FAANum,""), 0
            
            'PDF.SetFormFieldData "TopStatement", Chr(34) & GetAgentName(elt_account_number) _
            '    & " is in compliance with its TSA-approved security program and all applicable security directives.  Our number assigned by TSA is  " _
            '    & checkBlank(FAANum," ") _
			'	& ".  Our expiration date is "_ 
            '    & checkBlank(FAADate," ")_ 
            '    & ".  This shipment contains cargo originating from an unknown shipper not exempted by TSA.  This shipment must be transported on an ALL CARGO AIRCRAFT ONLY.  This certification is (i) made with the understanding that any intentional falsification may be subject to both civil and criminal penalties under 49CFR 1540.103 and Title 18 USC 1001, and (ii) subject to TSA recordkeeping requirements approved by TSA." & Chr(34), 0
            
            PDF.SetFormFieldData "TopStatement", Chr(34) & GetAgentName(elt_account_number) _
                & " is in compliance with its TSA-approved security program and all applicable security directives.  Our number assigned by TSA is  " _
                & checkBlank(FAANum," ") & ".  This shipment contains cargo originating from an unknown shipper not exempted by TSA.  This shipment must be transported ONLY on ALL-CARGO AIRCRAFT.  The individual whose name appears below certifies that he or she is an employee or authorized representative of " _
                & GetAgentName(elt_account_number) & " and understands that any fraudulent or false statement made in connection with this certification may subject this individual and " & GetAgentName(elt_account_number) & " to both civil penalties under 49 CFR Part 1540.103(b) and fines and/or imprisonment of not more than 5 years under 18 U.S.C. 1001." & Chr(34), 0
            PDF.SetFormFieldData "DestinationAndCountry", checkBlank(rs("Dest_Airport").value,"") & ", " & checkBlank(rs("dest_country").value,""), 0
            PDF.SetFormFieldData "ShipperListStatement" , "The name of each unknown shipper whose cargo has not been screened by the IAC.", 0
            PDF.SetFormFieldData "ItemListStatement" , "Identify which item being offered for transportation are under 16 ounces (453.6 grams)", 0
            PDF.SetFormFieldData "AgentStatement" , "Authorized Employee of " & GetAgentName(elt_account_number), 0
        End If    
        rs.Close()
        
    End Sub

%>
