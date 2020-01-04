<%

'////////////////////////////////////////////////////////////////////////////////////////////
'//
'// Created By Joon Park On Dec-11-2006
'//
'// Usage:
'//     sqlTxt = "Select Top 10 * from organization"
'//     Set all_list = read_table_with_sql(sqlTxt)
'//
'////////////////////////////////////////////////////////////////////////////////////////////


'----------------------- Set Array List -----------------------------------------------------

Function read_table_with_sql(sqlTxt)

    Dim returnList,tempTable,rs,i
    Dim dataSet
    
    Set returnList = Server.CreateObject("System.Collections.ArrayList")
    Set tempTable = Server.CreateObject("System.Collections.HashTable")
    Set rs = Server.CreateObject("ADODB.Recordset")
        
	Set rs = eltConn.execute(sqlTxt)
	
	If NOT rs.EOF and NOT rs.bof Then
	    Set tempTable = Server.CreateObject("System.Collections.HashTable")
	    For i = 0 To rs.Fields.Count-1
            tempTable.Add "col" & i, rs.Fields.Item(i).name
        Next
        returnList.Add tempTable
    End If
	
	Do While Not rs.EOF and NOT rs.bof
	    Set tempTable = Server.CreateObject("System.Collections.HashTable")
		For i = 0 To rs.Fields.Count-1
		    tempTable.Add rs.Fields.Item(i).name, checkBlank(rs.Fields.Item(i).value,"")
		Next
		returnList.Add tempTable
		rs.MoveNext
	Loop
	
    Set read_table_with_sql = returnList
End Function

'-------------------------- check blank and replace with default ------------------------------------

Function checkBlank(arg1,arg2)
    Dim result
    If IsNull(arg1) Then 
        result = arg2
    Else
		If Trim(arg1)="" Then
			result = arg2
		Else
			result = Trim(arg1)
		End If
    End If    
    checkBlank = result
    
End Function

%>
