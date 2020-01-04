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
	
    Dim PDF, reader
    Dim vOrgInfo1, vOrgInfo2, vTelFax, vMAWB, vShowTotal
    
    vMAWB = Request.Form("hMAWB")
    vShowTotal = Request.Form("chkShowTotal")
    
    get_agent_info()
    init_pdf()
    print_pdf_label(False)
    close_pdf(False)
    
    eltConn.Close()
    Set eltConn = Nothing
    
    Sub print_pdf_label(flag)
        Dim i, j, k, num, vLabelCount, vLabelStart
	    
	    num = 1
        For i=1 To Request.Form("chkHouse").Count
            For j=1 To Request.Form("txtHouse").Count
                If Request.Form("chkHouse")(i) = Request.Form("txtHouse")(j) Then
                    vLabelCount = CInt(Request.Form("txtLabelNo")(j)) * CInt(Request.Form("txtHousePCS")(j))
                    vLabelStart = CInt(Request.Form("hLabelStart")(j))
                    
                    For k=0 To vLabelCount-1
                        If i=Request.Form("chkHouse").Count And k=vLabelCount-1 Then
                        Else
                            PDF.SetFormFieldData "panel", "", 1
                        End If
                        PDF.SetFormFieldData "agentName" & num, vOrgInfo1, 0
                        PDF.SetFormFieldData "agentInfo" & num, vOrgInfo2, 0
                        PDF.SetFormFieldData "TeleFax" & num, vTelFax, 0
    	                
                        PDF.SetFormFieldData "airline" & num, Request.Form("hCarrierDesc")(j), 0
                        PDF.SetFormFieldData "destination" & num, Request.Form("txtToDesc")(j), 0
                        PDF.SetFormFieldData "MAWB" & num, vMAWB, 0
                        PDF.SetFormFieldData "HAWB" & num, Request.Form("txtHouse")(j), 0
                        
                        PDF.SetFormFieldData "shipperName" & num, GetBusinessName(Request.Form("hShipperAcct")(j)), 0
                        PDF.SetFormFieldData "shipper" & num, GetBusinessAddress(Request.Form("hShipperAcct")(j)), 0
                        PDF.SetFormFieldData "consigneeName" & num, GetBusinessName(Request.Form("hConsigneeAcct")(j)), 0
                        PDF.SetFormFieldData "consignee" & num, GetBusinessAddress(Request.Form("hConsigneeAcct")(j)), 0
                    
                        PDF.SetFormFieldData "hawb_piece" & num, k+1, 0
                        PDF.SetFormFieldData "hawb_total_piece" & num, vLabelCount, 0
                    
                        If vShowTotal = "Y" Then
                            PDF.SetFormFieldData "mawb_piece" & num, vLabelStart + k, 0
                            PDF.SetFormFieldData "mawb_total_piece" & num, Request.Form("hTotalPieces"), 0
                        End If
                        
	                    num = num + 1
	                    If num = 3 Or (i=Request.Form("chkHouse").Count And k=vLabelCount-1) Then
	                        num = 1
	                        PDF.FlattenRemainingFormFields = True
		                    reader=PDF.CopyForm(0, 0)
		                    PDF.ResetFormFields	
		                End If
	                Next
	                
                End If
            Next
        Next
        
    End Sub
    
    sub init_pdf

        DIM CustomerForm, fso, oFile
        
        oFile = Server.MapPath("../template")
        Set PDF = GetNewPDFObject
        reader = PDF.OpenOutputFile("MEMORY")
        Set fso = CreateObject("Scripting.FileSystemObject")
        CustomerForm = oFile & "/Customer/" & "shiplabel_" & elt_account_number & ".pdf"

        If fso.FileExists(CustomerForm) Then
	        reader = PDF.OpenInputFile(CustomerForm)
        Else
	        reader = PDF.OpenInputFile(oFile + "/shiplabel2.pdf")
        End If
        
        Set fso = nothing
        response.buffer = True
        
    end sub

    sub close_pdf(flag)

        PDF.CloseOutputFile
        response.expires = 0
        response.clear
        response.ContentType = "application/pdf"
        response.AddHeader "Content-Type", "application/pdf"
        response.AddHeader "Content-Disposition", "attachment; filename=SL" & Session.SessionID & ".pdf"
        WritePDFBinary(PDF)
        set PDF = nothing

    end sub
    
    
    Sub get_agent_info
        Dim SQL, rs
        
	    SQL= "select dba_name,business_address,business_city,business_state,business_zip,business_country,business_phone,business_fax from agent where elt_account_number = " & elt_account_number
	    Set rs = Server.CreateObject("ADODB.Recordset")
        rs.CursorLocation = adUseClient
        
	    rs.Open SQL, eltConn, adOpenForwardOnly,adLockReadOnly,adCmdText
	    If Not rs.EOF Then
		    vOrgInfo1=rs("dba_name")
		    vOrgInfo2=rs("business_address")
		    vOrgInfo2=vOrgInfo2 & chr(13) & rs("business_city") & "," & rs("business_state") & " " & rs("business_zip")
		    vOrgInfo2=vOrgInfo2 & chr(13) & rs("business_country")
		    vTelFax="Tel: " & rs("business_phone") & "    " & "Fax: " & rs("business_fax")
	    End If
	    rs.Close
    End Sub
%>