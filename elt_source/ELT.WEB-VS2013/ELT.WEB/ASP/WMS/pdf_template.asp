<%@ LANGUAGE = VBScript %>
<% Option Explicit %>
<!--  #INCLUDE FILE="../include/connection.asp" -->
<!--  #INCLUDE FILE="../include/header.asp" -->
 <!--  #INCLUDE FILE="../include/ScriptHeader.inc" -->
<!--  #include file="../include/recent_file.asp" -->
<!--  #INCLUDE FILE="../include/GOOFY_util_fun.inc" -->
<%  
    Call show_pdf_result

    Sub show_pdf_result
        
        Dim reader,fso,CustomerForm,bridge,oFile,PDF
        
        oFile = Server.MapPath("../template")
        Set PDF = Server.CreateObject("APToolkit.Object")
        reader = PDF.OpenOutputFile("MEMORY")

        Set fso = CreateObject("Scripting.FileSystemObject")
        '// filenamehere can be modified to any name
        CustomerForm=oFile & "/Customer/" & "filenamehere_" & elt_account_number & ".pdf"

        If fso.FileExists(CustomerForm) Then
            reader = PDF.OpenInputFile(CustomerForm)
        Else
            '// filenamehere can be modified to any name
            reader = PDF.OpenInputFile(oFile & "/filenamehere.pdf")
        End If

        Call get_param_values(PDF)
        '// uncomment this if logo added
        '// reader = PDF.AddLogo(oFile &  "/logo/Logo" & elt_account_number & ".pdf",1)
        reader = PDF.CopyForm(0, 0)
        PDF.CloseOutputFile
        bridge = PDF.BinaryImage
            
        Response.Expires = 0
        Response.Clear
        Response.ContentType = "application/pdf"
        Response.AddHeader "Content-Type", "application/pdf"
        '// filenamehere can be modified to any name
        Response.AddHeader "Content-Disposition", "inline; filename=filenamehere.pdf"
        Response.BinaryWrite bridge

        Set fso = Nothing
        Set PDF = Nothing
        Set reader = Nothing

    End Sub
    
    Sub get_param_values(PDF)
        
        PDF.SetFormFieldData " ", Request.Form(" ").Item & "", 0

        
    End Sub

%>