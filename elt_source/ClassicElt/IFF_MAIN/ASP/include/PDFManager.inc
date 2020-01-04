
<%
    Class PDFManager

        Private pdfObj, vMemory, oFormFields, vStamp, vStampRepeat, inputDir, fieldTable
        Public outputDir, FlattenRemainingFormFields, BinaryImage, aCounter, oProcessor
        
        Private Sub Class_Initialize()
            Set pdfObj = Server.CreateObject("easyPDF.PDFDocument.5")
            Set BinaryImage = Server.CreateObject("ADODB.Stream")
            Set fieldTable = Server.CreateObject("System.Collections.HashTable")
            outputDir = ""
            inputDir = ""
            vStamp = ""
            aCounter = 0
            Set oProcessor = CreateObject("easyPDF.PDFProcessor.5")
        End Sub
        
        Private Sub Class_Terminate()
            On Error Resume Next:
            pdfObj.Close(False)
            BinaryImage.Close
            Set pdfObj = Nothing
            Set BinaryImage = Nothing
            Set fieldTable = Nothing
            Set oProcessor = Nothing
        End Sub

'---------------------------------------------------------------------------------------

        Public Function OpenOutputFile(vOut)
            
            If Trim(UCase(vOut)) <> "MEMORY" Then
                outputDir = vOut
                vMemory = False
            Else
                outputDir = Server.MapPath("/IFF_MAIN/TEMP/PDFCache/") _
                    & "\" & Session.SessionID & " " & Replace(Date,"/","_") _
                    & " " & Replace(Time,":","_") & ".pdf"
                vMemory = True
            End If
            
            OpenOutputFile = aCounter
        End Function
        
        Public Function OpenInputFile(vIn)
            inputDir = vIn
            Set pdfObj = Server.CreateObject("easyPDF.PDFDocument.5")
            Set fieldTable = Server.CreateObject("System.Collections.HashTable")
            OpenInputFile = 1
        End Function
        
        Public Function AddLogo(vLogo,vRepeat)
            Dim filesys
            Set filesys = Server.CreateObject("Scripting.FileSystemObject")
            If filesys.FileExists(vLogo) Then
                vStamp = vLogo
                vStampRepeat = vRepeat
	        End If
            AddLogo = 1
        End Function
        
        Public Function CopyForm(vStart,vEnd)
            Dim isLogo
            isLogo = False
            
            Dim imgDir,appendDir
            imgDir = Replace(outputDir, ".", "0.")
            appendDir = Replace(outputDir, ".", "_" & aCounter & ".")
            
            If aCounter > 0 Then
                If LoadLogo(inputDir, imgDir) Then
                    pdfObj.Open(imgDir)
                    isLogo = True
                Else
                    pdfObj.Open(inputDir)
                End If
                Set oFormFields = pdfObj.FormFields
                Call PopulateData()
                pdfObj.SaveAs(appendDir)
                pdfObj.Close(False)
                Set pdfObj = Nothing
                
                Call oProcessor.merge(outputDir, appendDir, outputDir)
                
                If isLogo Then
                    DeleteFile(imgDir)
                End If
            Else
                If LoadLogo(inputDir, imgDir) Then
                    pdfObj.Open(imgDir)
                    isLogo = True
                Else
                    pdfObj.Open(inputDir)
                End If
                Set oFormFields = pdfObj.FormFields
                Call PopulateData()
                pdfObj.SaveAs(outputDir)
                pdfObj.Close(False)

                Set pdfObj = Nothing
                If isLogo Then
                    DeleteFile(outputDir & imgDir)
                End If
            End If
            
            aCounter = aCounter + 1
            
            Set pdfObj = Server.CreateObject("easyPDF.PDFDocument.5")
            Set fieldTable = Server.CreateObject("System.Collections.HashTable")
        End Function
    
        Public Sub SetFormFieldData(vField,vValue,vFlag)
            On Error Resume Next:
            fieldTable.Add UCase(vField), vValue
        End Sub
        

'---------------------------------------------------------------------------------------
        
        Private Function LoadLogo(inFile, outFile)
            Dim ActivePDF, ActivePDFReader
            Set ActivePDF = Server.CreateObject("APToolkit.Object")
            If vStamp <> "" Then
                ActivePDFReader = ActivePDF.OpenInputFile(inFile)
                ActivePDFReader = ActivePDF.OpenOutputFile(outFile)
                ActivePDFReader = ActivePDF.AddLogo(vStamp,vStampRepeat)
                ActivePDFReader = ActivePDF.CopyForm(0, 0)
                ActivePDF.CloseOutputFile
                Set ActivePDFReader = Nothing
                Set ActivePDF = Nothing
                LoadLogo = True
            Else
                LoadLogo = False
            End If
        End Function
        
        Private Sub DisplayLogo()
            Dim oProcessor
            Set oProcessor = CreateObject("easyPDF.PDFProcessor.5")

            oProcessor.AddStamp outputDir, _
                outputDir, _
                vStamp, _ 
                0, _ 
                PRN_STAMP_HPOS_LEFT, _
                PRN_STAMP_VPOS_TOP, _
                PRN_STAMP_ZORDER_TOP, _
                0, _
                0, _
                RGB(0, 0, 0), _
                100
            Set oProcessor = Nothing
        End Sub
        
        Private Sub PopulateData()
            Dim i, keyStr, valueStr, oFormField
            
            For Each oFormField in oFormFields
                keyStr = oFormField.Name
                valueStr = ""
                On Error Resume Next:
                valueStr = fieldTable(UCase(keyStr))
                oFormField.Value = valueStr
            Next
        End Sub
        
        Private Sub GetBinaryOutput(vFile)
	        BinaryImage.Open
	        BinaryImage.Type = 1
	        BinaryImage.LoadFromFile vFile
        End Sub

        Private Sub DeleteFile(vDir)
            Dim filesys
            Set filesys = Server.CreateObject("Scripting.FileSystemObject")
            
            If filesys.FileExists(vDir) Then
                filesys.DeleteFile vDir
	        End If
        End Sub
        
'---------------------------------------------------------------------------------------

        Public Function CloseOutputFile()
            If aCounter > 1 Then
                Dim aFileNames,i
                reDim aFileNames(aCounter-1)
                aFileNames(0) = CStr(outputDir)
                For i=1 To aCounter-1
                    aFileNames(i) = CStr(Replace(outputDir, ".", "_" & i & "."))
                Next
                
                'On Error Resume Next:
                'oProcessor.MergeBatch aFileNames, outputDir
                
                For i=1 To aCounter-1
                    DeleteFile(aFileNames(i))
                Next
            End If

            ON Error Resume Next:
            oProcessor.Optimize outputDir, outputDir
            
            If vMemory Then
                GetBinaryOutput(outputDir)
                DeleteFile(outputDir)
            End If
            
            CloseOutputFile = 1
        End Function
        
        Public Function ResetFormFields()
            ResetFormFields = 1
        End Function
        
    End Class
    
    Sub WritePDFBinary(oPDF)
        Dim result,rsObj,SQL
        Set rsObj = Server.CreateObject("ADODB.Recordset")
        SQL = "SELECT international_pdf FROM user_profile WHERE elt_account_number=" & elt_account_number
        rsObj.CursorLocation = adUseClient
        rsObj.Open SQL, eltConn, adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rsObj.activeConnection = Nothing
    	
	    If Not rsObj.EOF And Not rsObj.BOF Then
	        If rsObj("international_pdf") = "Y" Then
	            Response.BinaryWrite oPDF.BinaryImage.Read
	        Else
	            Response.BinaryWrite oPDF.BinaryImage
	        End If
	    End If
        rsObj.Close()
    End Sub
    
    Function GetNewPDFObject()
        Dim result,rsObj,oPDF,SQL
        Set rsObj = Server.CreateObject("ADODB.Recordset")
        SQL = "SELECT international_pdf FROM user_profile WHERE elt_account_number=" & elt_account_number
        rsObj.CursorLocation = adUseClient
        rsObj.Open SQL, eltConn, adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rsObj.activeConnection = Nothing
    	
	    If Not rsObj.EOF And Not rsObj.BOF Then
	        If rsObj("international_pdf") = "Y" Then
	            Set oPDF = new PDFManager
	        Else
	            Set oPDF = Server.CreateObject("APToolkit.Object")
	        End If
	    End If
        rsObj.Close()
        Set GetNewPDFObject = oPDF
    End Function

%>