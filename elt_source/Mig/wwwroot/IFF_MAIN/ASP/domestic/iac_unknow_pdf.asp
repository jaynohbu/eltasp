<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/PDFManager.inc" -->
<!--  #INCLUDE FILE="../include/GOOFY_data_manager.inc" -->
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
	
    Dim vMAWB

    vMAWB = Request.QueryString("MAWB").Item
    '// On Error Resume Next:
    
    Call show_pdf_result

    Sub show_pdf_result
        
        Dim reader,fso,CustomerForm,bridge,oFile,PDF
        
        oFile = Server.MapPath("../template")
        Set PDF = Server.CreateObject("APToolkit.Object")
        reader = PDF.OpenOutputFile("MEMORY")

        Set fso = CreateObject("Scripting.FileSystemObject")
        CustomerForm=oFile & "/Customer/" & "iac_" & elt_account_number & ".pdf"

        If fso.FileExists(CustomerForm) Then
            reader = PDF.OpenInputFile(CustomerForm)
        Else
            reader = PDF.OpenInputFile(oFile & "/iac_unknown.pdf")
        End If

        Call get_param_values(PDF)
        reader = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
        reader = PDF.CopyForm(0, 0)
        PDF.CloseOutputFile
            
        Response.Expires = 0
        Response.Clear
        Response.ContentType = "application/pdf"
        Response.AddHeader "Content-Type", "application/pdf"
        Response.AddHeader "Content-Disposition", "inline; filename=iac_unknown.pdf"
        Response.BinaryWrite PDF.BinaryImage

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
            PDF.SetFormFieldData "Destination", checkBlank(rs("Dest_Airport").value,""), 0
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
            
            PDF.SetFormFieldData "TopStatement", Chr(34) & GetAgentName(elt_account_number) _
                & " is in compliance with its TSA-approved security program and all applicable security directives.  Our number assigned by TSA is  " _
                & checkBlank(FAANum," ") _
				& ".  Our expiration date is "_ 
                & checkBlank(FAADate," ")_ 
                & ".  This shipment contains cargo originating from an unknown shipper not exempted by TSA.  This shipment must be transported on an ALL CARGO AIRCRAFT ONLY.  This certification is (i) made with the understanding that any intentional falsification may be subject to both civil and criminal penalties under 49CFR 1540.103 and Title 18 USC 1001, and (ii) subject to TSA recordkeeping requirements approved by TSA." & Chr(34), 0
            
            'PDF.SetFormFieldData "TopStatement" , Chr(34) & GetAgentName(elt_account_number) _
            '    & " is in compliance with its TSA-approved security program and all appropriate emergency amendment(s).  Our number assigned by the TSA is " _
            '    & checkBlank(FAANum," ") _
            '    & ". No cargo from an unknown shipper is being offered for transportation.  All cargo is EITHER from a verified shipper that was a known shipper prior to September 1, 1999, with active account showing 24 shipments since September 1, 1999, or cargo from a known shipper that has been visited by " _
            '    & GetAgentName(elt_account_number) & " since October 1, 2001.  This IAC understands that any intentional falsification of certification to an air carrier may be subject to both civil and criminal penalties under 49 CFR 1544.209 and Title 18 USC 1001." & Chr(34), 0
            
        End If    
        rs.Close()
        
    End Sub

%>
