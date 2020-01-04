<%

'////////////////////////////////////////////////////////////////////////////////////////////
'//
'// Created By Joon Park On Dec-11-2006
'//
'// Usage:
'//
'////////////////////////////////////////////////////////////////////////////////////////////


'-------------------------- Update Data in Table ------------------------------------------------------


Class DataManager

    '// DataList contains list of datatables
    '// keyArray has db comlums names, HTMLkeyArray has input names within a form
    '// keyArray and HTMLKeyArray are mapped with index
    
    Dim DataList,KeyArray(),HTMLKeyArray()
    
    Private Sub Class_Initialize()
        Set DataList = Server.CreateObject("System.Collections.ArrayList")
    End Sub
    
    Private Sub Class_Terminate()
        Set DataList = Nothing
    End Sub

'-------------------- Set DataList --------------------------------------------------    
    Public Function SetDataList(sqlTxt)
        If Not IsNull(sqlTxt) And Trim(sqlTxt) <> "" Then
            Dim tempTable,rs,i,j,tempFld
            
            Set rs = Server.CreateObject("ADODB.Recordset")
	        rs.CursorLocation = adUseClient

	        rs.Open sqlTxt, eltConn, adOpenForwardOnly,adLockReadOnly,adCmdText
	        Set rs.activeConnection = Nothing

            reDim KeyArray(rs.Fields.Count-1)
            j = 0
            
	        Do While Not rs.EOF and NOT rs.BOF
	            Set tempTable = Server.CreateObject("System.Collections.HashTable")
		        For i = 0 To rs.Fields.Count-1
		            tempFld = rs.Fields.Item(i).name
		            Do While tempTable.ContainsKey(tempFld)
		                tempFld = tempFld & "_X"
		            Loop
		            
                    If rs.Fields(j).Type = 135 And IsDate(rs.Fields.Item(i).value) Then
                        tempTable.Add tempFld, FormatDatePlus(rs.Fields.Item(i).value,"mm/dd/yyyy")
                    Else
                        If IsNull(rs.Fields.Item(i).value) Then
                            tempTable.Add tempFld, Null
                        Else
                            tempTable.Add tempFld, Cstr(rs.Fields.Item(i).value)
                        End If
                    End If

                    KeyArray(j) = tempFld
                    j = j + 1
		        Next
		        j = 0
		        DataList.Add tempTable
		        rs.MoveNext
	        Loop
	        rs.Close 
        End If       
    End Function
'-------------------- Get DataList ---------------------------------------------------
'// Use GetRowTable instead when 1 row table is needed
'/////////////////////////////////////////////////////////////////////////////////////

    Public Function GetDataList()
        Set GetDataList = DataList
    End Function
    
    Public Function GetKeyArray()
        GetKeyArray = KeyArray
    End Function 
    
'-------------------- Update Mulitple Rows --------------------------------------------------   
    Public Function UpdateDBRows(sqlTxt)
        Dim i
        For i=0 To DataList.Count-1
            Call UpdateDBRow(sqlTxt,DataList(i))
        Next
    End Function
    
'-------------------- Update DB Rows --------------------------------------------------   
    Public Function UpdateDBRow(sqlTxt,DataTable)

        Dim j,rs,done,entryData,resVal
        resVal = False
        
        If DataTable.Count > 0 Then
            Set rs = Server.CreateObject("ADODB.Recordset")

            rs.Open sqlTxt,eltConn,adOpenStatic,adLockPessimistic,adCmdText

            If rs.EOF then
                rs.AddNew
            End If
            
            For j=0 To UBound(KeyArray)
                If DataTable.ContainsKey(KeyArray(j))Then            
                    entryData = DataTable(KeyArray(j))
                    If rs.Fields(j).Properties.Item("ISAUTOINCREMENT").Value = False _
                        And Not IsNull(entryData) And Not IsEmpty(entryData) Then
                        
                        If rs.Fields(j).Type = 135 And checkBlank(entryData,"") <> "" Then
                            rs(KeyArray(j)) = CDate(entryData)
                        Elseif rs.Fields(j).Type = 135 And checkBlank(entryData,"") = "" Then
                        Elseif rs.Fields(j).Type = 131 Or rs.Fields(j).Type = 5 Then
                            rs(KeyArray(j)) = checkBlank(entryData,0)
                        Elseif Not IsNull(entryData) Then
                            rs(KeyArray(j)) = entryData
                        End If
                        
                    End If
                End If
            Next

            rs.Update
            
            If rs.Status = 0 Then
                resVal = True
            End If
            
            rs.Close

            UpdateDBRow = resVal
        End If

    End Function
    
    Public Function InsertDBRow(sqlTxt,DataTable)
    
        Dim j,rs,done,entryData,resVal
        resVal = False

        If DataTable.Count > 0 Then
            Set rs = Server.CreateObject("ADODB.Recordset")

            rs.Open sqlTxt,eltConn,adOpenStatic,adLockPessimistic,adCmdText

            If rs.EOF then
                rs.AddNew
            
                For j=0 To UBound(KeyArray)
                    If DataTable.ContainsKey(KeyArray(j))Then            
                        entryData = DataTable(KeyArray(j))
                        If rs.Fields(j).Properties.Item("ISAUTOINCREMENT").Value = False _
                            And Not IsNull(entryData) And Not IsEmpty(entryData) Then
                            
                            If rs.Fields(j).Type = 135 And checkBlank(entryData,"") <> "" Then
                                rs(KeyArray(j)) = CDate(entryData)
                            Elseif rs.Fields(j).Type = 135 And checkBlank(entryData,"") = "" Then
                            Elseif rs.Fields(j).Type = 131 Or rs.Fields(j).Type = 5 Then
                                rs(KeyArray(j)) = checkBlank(entryData,0)
                            Elseif Not IsNull(entryData) Then
                                rs(KeyArray(j)) = entryData
                            End If
                            
                        End If
                    End If
                Next

                rs.Update
            
                If rs.Status = 0 Then
                    resVal = True
                End If
            
                rs.Close
            End If
            
            InsertDBRow = resVal
        End If

    End Function
    
    Public Function Return1stUpdateDBRow(sqlTxt,DataTable,keySQLTtxt)
        Dim j,rs,done,entryData,resVal
        resVal = -1
        
        If DataTable.Count > 0 Then
            Set rs = Server.CreateObject("ADODB.Recordset")

            rs.Open sqlTxt,eltConn,adOpenStatic,adLockPessimistic,adCmdText
               
            If rs.EOF Then
                rs.AddNew
            Else
                resVal = clng(rs(0).value)
            End If

            For j=0 To UBound(KeyArray)
                If DataTable.ContainsKey(KeyArray(j))Then            
                    entryData = DataTable(KeyArray(j))
                    If rs.Fields(j).Properties.Item("ISAUTOINCREMENT").Value = False _
                        And Not IsNull(entryData) And Not IsEmpty(entryData) Then
                        
                        If rs.Fields(j).Type = 135 And checkBlank(entryData,"") <> "" Then
                            rs(KeyArray(j)) = CDate(entryData)
                        Elseif rs.Fields(j).Type = 135 And checkBlank(entryData,"") = "" Then
                        Elseif rs.Fields(j).Type = 131 Or rs.Fields(j).Type = 5 Then
                            rs(KeyArray(j)) = checkBlank(entryData,0)
                        Elseif Not IsNull(entryData) Then
                            rs(KeyArray(j)) = entryData
                        End If
                        
                    End If
                End If
            Next

            rs.Update
            rs.Close
            rs.Open keySQLTtxt,eltConn,adOpenStatic,adLockPessimistic,adCmdText

            If Not rs.EOF And Not rs.BOF And resVal = -1 Then
                resVal = rs(0).value
            End If

            rs.Close
            
            If IsNull(resVal) Or resVal = "" Then
                resVal = -1
            End If

            Return1stUpdateDBRow = resVal
        End If

    End Function
   
'-------------------- Set Column Keys --------------------------------------------------   
    
    Public Function SetColumnKeys(tableName)
        Dim rs, i, sqlTxt
 
        Set rs = Server.CreateObject("ADODB.Recordset")
        sqlTxt = "SELECT TOP 0 * FROM " & tableName

	    Set rs = eltConn.execute(sqlTxt)
        
        reDim KeyArray(rs.Fields.Count-1)
        reDim HTMLKeyArray(rs.Fields.Count-1)
        
        For i = 0 To rs.Fields.Count-1
            KeyArray(i) = rs.Fields.Item(i).name
        Next
        rs.Close
    End Function
    
'-------------------- Get Row Table --------------------------------------------------   
    Public Function GetRowTable(rowNum)
        Dim rowTable
        Set rowTable = Server.CreateObject("System.Collections.HashTable")
        On Error Resume Next:
        If Not IsNull(DataList) And Not IsEmpty(DataList) Then
            Set rowTable = DataList(rowNum)
        End If
        Set GetRowTable = rowTable
    End Function
    
'-------------------- Add Request Key --------------------------------------------------   
    Public Function AddRequestKey(htmlKey,colKey)
        Dim i
        
        For i=0 To UBound(KeyArray)
            If KeyArray(i) = colKey Then
                HTMLKeyArray(i) = htmlKey
            End If
        Next
    End Function
    
'------------------- Load Request Values ----------------------------------------------
    Public Function MakeRequestTable(req)
        Dim i,returnTable
        Set returnTable = Server.CreateObject("System.Collections.HashTable")
        For i=0 To UBound(KeyArray)
            If Not IsEmpty(HTMLKeyArray(i)) Then
                returnTable.Add KeyArray(i), req.Form(HTMLKeyArray(i)).Item
            Else
                returnTable.Add KeyArray(i), ""
            End If
        Next
        Set MakeRequestTable = returnTable
    End Function
    
    
End Class

%>
