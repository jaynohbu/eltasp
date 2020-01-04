<%

'///////////////////////////////////////////////////////////////////////////////////////////////////////
'//  
'//  Created By Joon Park On Dec-7-2006
'//
'//  This file can be included in other asp pages when organization list is needed
'//  shipper,consignee,agent,trucker,carrier for now (can be added later)
'//  make_organization_list function creates all of them at once (tabes elt account number as parameter)
'//
'//  Usage: 
'//     1) Call make_organization_list("80002000")  
'//     2) Set shipper_list = get_shipper_list("80002000") etc.
'// 
'//  Returns:
'//     Each list is ArrayList Object Containning Hashtable emelments
'//     All list contains account, name, info fields in the hashtable
'//     shipper list has first hashtable with default information
'//     carrier list has additionall info: code, SCAC fields
'//
'//  Remarks:
'//     account, name, info (code, SCAC) in Hash Table
'//     These fields can be invoked in following code argument
'//     shipper_list(index)("account/name/code...")
'//
'//  Hope this will help U guys... Thnx to Joon  ^_____________________^
'//
'///////////////////////////////////////////////////////////////////////////////////////////////////////


Public ShipperList,ConsigneeList,AgentList,TruckerList,CarrierList


Sub make_organization_list(elt_account_number)

    Set ShipperList = Server.CreateObject("System.Collections.ArrayList")
    Set ShipperList = get_shipper_list(elt_account_number)
    Set ConsigneeList = Server.CreateObject("System.Collections.ArrayList")
    Set ConsigneeList = get_consignee_list(elt_account_number)
    Set AgentList = Server.CreateObject("System.Collections.ArrayList")
    Set AgentList = get_agent_list(elt_account_number)
    Set TruckerList = Server.CreateObject("System.Collections.ArrayList")
    Set TruckerList = get_trucker_list(elt_account_number)
    Set CarrierList = Server.CreateObject("System.Collections.ArrayList")
    Set CarrierList = get_carrier_list(elt_account_number)

End Sub

'----------------------- Set Shipper List -----------------------------------------------------

Function get_shipper_list(elt_account_number)

    Dim returnList,tempTable,SQL,rs
    DIM tmpShipper_name,tmpShipper_info
    
    Set returnList = Server.CreateObject("System.Collections.ArrayList")
    Set tempTable = Server.CreateObject("System.Collections.HashTable")
    Set rs = Server.CreateObject("ADODB.Recordset")
    
    tempTable.Add "account", "0"
    tempTable.Add "name", "Select One"
    tempTable.Add "info", ""
    tempTable.Add "address", ""
    returnList.Add tempTable
    
    SQL= "select isnull(dba_name,'') as dba_name,isnull(business_address,'') as business_address" _
        & ",isnull(business_city,'') as business_city,isnull(business_state,'') as business_state" _
        & ",isnull(business_zip,'') as business_zip,isnull(business_country,'') as business_country" _
        & ",isnull(business_phone,'') as business_phone,isnull(business_fax,'') as business_fax " _
        & "from agent where elt_account_number = " & elt_account_number

    eltConn.CursorLocation = adUseClient
    rs.CursorLocation = adUseClient
    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
	'// rs.Open SQL,eltConn,adOpenStatic,adLockBatchOptimistic,adCmdText
    Set rs.ActiveConnection = Nothing
    
    if Not rs.EOF Then
    
        Set tempTable = Server.CreateObject("System.Collections.HashTable")
	    tmpShipper_name = rs("dba_name")
	    tmpShipper_info = rs("dba_name") & chr(10) & rs("business_address") _
	        & chr(10) & rs("business_city") & "," & rs("business_state") & " " & rs("business_zip") _
	        & "," & rs("business_country") & chr(10)
	    
	    If Not IsNull(rs("business_phone")) And Trim(rs("business_phone")) <> "" Then
	        tmpShipper_info = tmpShipper_info & "Tel:" & rs("business_phone") & " "
	    End If
	    If Not IsNull(rs("business_fax")) And Trim(rs("business_fax")) <> "" Then
	        tmpShipper_info = tmpShipper_info & "Fax:" & rs("business_fax") & " "
	    End If
        tmpShipper_name = formatString(tmpShipper_name)
        tmpShipper_info = formatString(tmpShipper_info)
        
        tempTable.Add "account", elt_account_number
        tempTable.Add "name", tmpShipper_name
        tempTable.Add "info", elt_account_number & "-" & tmpShipper_info
        tempTable.Add "address", tmpShipper_info
        tempTable.Add "class", ""
        tempTable.Add "address2", ""
        returnList.Add tempTable
    end if
    
    rs.Close
    
	SQL= "select isnull(DBA_NAME,'') as dba_name,isnull(business_address,'') as business_address" _
        & ",isnull(business_city,'') as business_city,isnull(business_state,'') as business_state" _
        & ",isnull(business_zip,'') as business_zip,isnull(business_country,'') as business_country" _
        & ",isnull(business_phone,'') as business_phone,isnull(business_fax,'') as business_fax " _
        & ",is_shipper,org_account_number,isnull(' - ' + class_code,'') as class_code,isnull(char(13) + business_address2,'') as business_address2" _
        & " FROM organization where elt_account_number = " & elt_account_number _
		& " AND is_shipper='Y' ORDER BY dba_name"
	
	eltConn.CursorLocation = adUseClient
	rs.CursorLocation = adUseClient	
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
	'// rs.Open SQL,eltConn,adOpenStatic,adLockBatchOptimistic,adCmdText
    Set rs.ActiveConnection = Nothing
    
	Do While Not rs.EOF and NOT rs.bof
	
	    Set tempTable = Server.CreateObject("System.Collections.HashTable")
		tempTable.Add "account", rs("org_account_number").value
		
		If rs("business_State").value = "" Then
			tmpShipper_info =  rs("DBA_NAME").value _
				& chr(10) & rs("business_address").value & rs("business_address2").value _
				& chr(10) & rs("business_city").value _
				& "," & rs("business_Country").value & chr(10) 
		Else
			 tmpShipper_info = rs("DBA_NAME").value _
				& chr(10) & rs("business_address").value & rs("business_address2").value _
				& chr(10) & rs("business_city").value _
				& "," & rs("business_State").value & " " & rs("business_Zip").value _
				& "," & rs("business_Country").value & chr(10) 
		End If
		
		If Not IsNull(rs("business_phone")) And Trim(rs("business_phone")) <> "" Then
	        tmpShipper_info = tmpShipper_info & "Tel:" & rs("business_phone") & " "
	    End If
	    If Not IsNull(rs("business_fax")) And Trim(rs("business_fax")) <> "" Then
	        tmpShipper_info = tmpShipper_info & "Fax:" & rs("business_fax") & " "
	    End If
		
		tmpShipper_name = formatString(rs("dba_name").value) & rs("class_code").value
        tmpShipper_info = formatString(tmpShipper_info)
        
        tempTable.Add "name", tmpShipper_name
		tempTable.Add "info", rs("org_account_number").value & "-" & tmpShipper_info
		tempTable.Add "address", tmpShipper_info
		tempTable.Add "class", rs("class_code").value
        tempTable.Add "address2", rs("business_address2").value
		returnList.Add tempTable
		rs.MoveNext
	Loop
	
	rs.Close
	Set rs = Nothing
	
    Set get_shipper_list = returnList
End Function

'----------------------- Set Consignee List -----------------------------------------------------

Function get_consignee_list(elt_account_number)

    Dim returnList,tempTable,SQL,rs,temp_info
    
    Set returnList = Server.CreateObject("System.Collections.ArrayList")
    Set tempTable = Server.CreateObject("System.Collections.HashTable")
    Set rs = Server.CreateObject("ADODB.Recordset")

    tempTable.Add "account", "0"
    tempTable.Add "name", "Select One"
    tempTable.Add "info", ""
    returnList.Add tempTable
    
	SQL= "select isnull(DBA_NAME,'') as dba_name,isnull(business_address,'') as business_address" _
        & ",isnull(business_city,'') as business_city,isnull(business_state,'') as business_state" _
        & ",isnull(business_zip,'') as business_zip,isnull(business_country,'') as business_country" _
        & ",isnull(business_phone,'') as business_phone,isnull(business_fax,'') as business_fax " _
        & ",is_consignee,is_shipper,org_account_number,isnull(' - ' + class_code,'') as class_code,isnull(char(13) + business_address2,'') as business_address2" _
        & " FROM organization where elt_account_number = " & elt_account_number _
		& " AND (is_consignee='Y' OR is_shipper='Y') ORDER BY dba_name"
	
	eltConn.CursorLocation = adUseClient
	rs.CursorLocation = adUseClient	
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
	'// rs.Open SQL,eltConn,adOpenStatic,adLockBatchOptimistic,adCmdText
    Set rs.ActiveConnection = Nothing

	Do While Not rs.EOF and NOT rs.bof
	
	    Set tempTable = Server.CreateObject("System.Collections.HashTable")
		tempTable.Add "account", rs("org_account_number").value
		tempTable.Add "name", formatString(rs("DBA_NAME").value) & rs("class_code").value
		
		If rs("business_State").value = "" Then
			temp_info =  rs("org_account_number").value & "-" & rs("DBA_NAME").value _
                & chr(10) & rs("business_address").value & rs("business_address2").value _
                & chr(10) & rs("business_city").value _
				& "," & rs("business_Country").value & chr(10) 
		Else
			temp_info =  rs("org_account_number").value & "-" & rs("DBA_NAME").value _
				& chr(10) & rs("business_address").value & rs("business_address2").value _
				& chr(10) & rs("business_city").value _
				& "," & rs("business_State").value & " " & rs("business_Zip").value _
				& "," & rs("business_Country").value & chr(10) 
		End If
		
		If Not IsNull(rs("business_phone")) And Trim(rs("business_phone")) <> "" Then
	        temp_info = temp_info & "Tel:" & rs("business_phone") & " "
	    End If
	    If Not IsNull(rs("business_fax")) And Trim(rs("business_fax")) <> "" Then
	        temp_info = temp_info & "Fax:" & rs("business_fax") & " "
	    End If
	    tempTable.Add "info", formatString(temp_info)
	    tempTable.Add "class", rs("class_code").value
        tempTable.Add "address2", rs("business_address2").value
		returnList.Add tempTable
		rs.MoveNext
	Loop
	
	rs.Close
	Set rs = Nothing
	
    Set get_consignee_list = returnList
End Function

'----------------------- Set Agent List --------------------------------------------------------

Function get_agent_list(elt_account_number)

    Dim returnList,tempTable,SQL,rs,temp_info
    
    Set returnList = Server.CreateObject("System.Collections.ArrayList")
    Set tempTable = Server.CreateObject("System.Collections.HashTable")
    Set rs = Server.CreateObject("ADODB.Recordset")

    tempTable.Add "account", "0"
    tempTable.Add "name", "Select One"
    tempTable.Add "info", ""
    returnList.Add tempTable
    
	SQL= "select isnull(DBA_NAME,'') as dba_name,isnull(business_address,'') as business_address" _
        & ",isnull(business_city,'') as business_city,isnull(business_state,'') as business_state" _
        & ",isnull(business_zip,'') as business_zip,isnull(business_country,'') as business_country" _
        & ",isnull(business_phone,'') as business_phone,isnull(business_fax,'') as business_fax " _
        & ",is_agent,org_account_number,isnull(' - ' + class_code,'') as class_code,isnull(char(13) + business_address2,'') as business_address2" _
        & " FROM organization where elt_account_number = " & elt_account_number _
		& " AND is_agent='Y' ORDER BY dba_name"
	
	eltConn.CursorLocation = adUseClient
	rs.CursorLocation = adUseClient	
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
	'// rs.Open SQL,eltConn,adOpenStatic,adLockBatchOptimistic,adCmdText
    Set rs.ActiveConnection = Nothing

	Do While Not rs.EOF and NOT rs.bof
	
	    Set tempTable = Server.CreateObject("System.Collections.HashTable")
		tempTable.Add "account", rs("org_account_number").value
		tempTable.Add "name", formatString(rs("DBA_NAME").value) & rs("class_code").value
		
		If rs("business_State").value = "" Then
			temp_info = rs("org_account_number").value & "-" & rs("DBA_NAME").value _
				& chr(10) & rs("business_address").value & rs("business_address2").value _
				& chr(10) & rs("business_city").value _
				& "," & rs("business_Country").value & chr(10)
		Else
			temp_info = rs("org_account_number").value & "-" & rs("DBA_NAME").value _
				& chr(10) & rs("business_address").value & rs("business_address2").value _
				& chr(10) & rs("business_city").value _
				& "," & rs("business_State").value & " " & rs("business_Zip").value _
				& "," & rs("business_Country").value & chr(10)
		End If
        If Not IsNull(rs("business_phone")) And Trim(rs("business_phone")) <> "" Then
	        temp_info = temp_info & "Tel:" & rs("business_phone") & " "
	    End If
	    If Not IsNull(rs("business_fax")) And Trim(rs("business_fax")) <> "" Then
	        temp_info = temp_info & "Fax:" & rs("business_fax") & " "
	    End If
	    tempTable.Add "info", formatString(temp_info)
	    tempTable.Add "class", rs("class_code").value
        tempTable.Add "address2", rs("business_address2").value
		returnList.Add tempTable
		rs.MoveNext
	Loop
	
	rs.Close
	Set rs = Nothing
	
    Set get_agent_list = returnList
End Function

'----------------------- Set Trucker List --------------------------------------------------------

Function get_trucker_list(elt_account_number)

    Dim returnList,tempTable,SQL,rs,temp_info
    
    Set returnList = Server.CreateObject("System.Collections.ArrayList")
    Set tempTable = Server.CreateObject("System.Collections.HashTable")
    Set rs = Server.CreateObject("ADODB.Recordset")

    tempTable.Add "account", "0"
    tempTable.Add "name", "Select One"
    tempTable.Add "info", ""
    returnList.Add tempTable
    
	SQL= "select isnull(DBA_NAME,'') as dba_name,isnull(business_address,'') as business_address" _
        & ",isnull(business_city,'') as business_city,isnull(business_state,'') as business_state" _
        & ",isnull(business_zip,'') as business_zip,isnull(business_country,'') as business_country" _
        & ",isnull(business_phone,'') as business_phone,isnull(business_fax,'') as business_fax " _
        & ",z_is_trucker,org_account_number,isnull(' - ' + class_code,'') as class_code,isnull(char(13) + business_address2,'') as business_address2" _
        & " FROM organization where elt_account_number = " & elt_account_number _
		& " AND z_is_trucker='Y' ORDER BY dba_name"
	
	eltConn.CursorLocation = adUseClient
	rs.CursorLocation = adUseClient	
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
	'// rs.Open SQL,eltConn,adOpenStatic,adLockBatchOptimistic,adCmdText
    Set rs.ActiveConnection = Nothing

	Do While Not rs.EOF and NOT rs.bof
	
	    Set tempTable = Server.CreateObject("System.Collections.HashTable")
		tempTable.Add "account", rs("org_account_number").value
		tempTable.Add "name", formatString(rs("DBA_NAME").value) & rs("class_code").value
		
		If rs("business_State").value = "" Then
			temp_info = rs("org_account_number").value & "-" & rs("DBA_NAME").value _
				& chr(10) & rs("business_address").value & rs("business_address2").value _
				& chr(10) & rs("business_city").value _
				& "," & rs("business_Country").value & chr(10)
		Else
			temp_info = rs("org_account_number").value & "-" & rs("DBA_NAME").value _
				& chr(10) & rs("business_address").value & rs("business_address2").value _
				& chr(10) & rs("business_city").value _
				& "," & rs("business_State").value & " " & rs("business_Zip").value _
				& "," & rs("business_Country").value & chr(10)
		End If
		
        If Not IsNull(rs("business_phone")) And Trim(rs("business_phone")) <> "" Then
	        temp_info = temp_info & "Tel:" & rs("business_phone") & " "
	    End If
	    If Not IsNull(rs("business_fax")) And Trim(rs("business_fax")) <> "" Then
	        temp_info = temp_info & "Fax:" & rs("business_fax") & " "
	    End If
	    tempTable.Add "info", formatString(temp_info)
	    tempTable.Add "class", rs("class_code").value
        tempTable.Add "address2", rs("business_address2").value
		returnList.Add tempTable
		rs.MoveNext
	Loop
	
	rs.Close
	Set rs = Nothing
	
    Set get_trucker_list = returnList
End Function

'----------------------- Set Carrier List --------------------------------------------------------

Function get_carrier_list(elt_account_number)

    Dim returnList,tempTable,SQL,rs,temp_info
    
    Set returnList = Server.CreateObject("System.Collections.ArrayList")
    Set tempTable = Server.CreateObject("System.Collections.HashTable")
    Set rs = Server.CreateObject("ADODB.Recordset")

    tempTable.Add "account", ""
    tempTable.Add "code", ""
    tempTable.Add "SCAC", ""
    tempTable.Add "name", "Select One"
    tempTable.Add "info", ""
    returnList.Add tempTable
    
	SQL= "select isnull(DBA_NAME,'') as dba_name,isnull(business_address,'') as business_address" _
        & ",isnull(business_city,'') as business_city,isnull(business_state,'') as business_state" _
        & ",isnull(business_zip,'') as business_zip,isnull(business_country,'') as business_country" _
        & ",isnull(business_phone,'') as business_phone,isnull(business_fax,'') as business_fax " _
        & ",is_carrier,org_account_number,carrier_code,carrier_id" _
        & ",isnull(class_code,'') as class_code,isnull(' - ' + business_address2,'') as business_address2" _
        & " FROM organization where elt_account_number = " & elt_account_number _
		& " AND is_carrier='Y' AND carrier_code <> '' ORDER BY dba_name"
	
	eltConn.CursorLocation = adUseClient
	rs.CursorLocation = adUseClient	
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
	'// rs.Open SQL,eltConn,adOpenStatic,adLockBatchOptimistic,adCmdText
    Set rs.ActiveConnection = Nothing

	Do While Not rs.EOF and NOT rs.bof
	
	    Set tempTable = Server.CreateObject("System.Collections.HashTable")
		tempTable.Add "account", rs("org_account_number").value
		tempTable.Add "code", rs("carrier_code").value
		tempTable.Add "SCAC", rs("carrier_id").value
		tempTable.Add "name", formatString(rs("DBA_NAME").value) & rs("class_code").value
		
		If rs("business_State").value = "" Then
			temp_info = rs("DBA_NAME").value _
				& chr(10) & rs("business_address").value & rs("business_address2").value _
				& chr(10) & rs("business_city").value _
				& "," & rs("business_Country").value & chr(10) 
		Else
			 temp_info = rs("DBA_NAME").value _
				& chr(10) & rs("business_address").value & rs("business_address2").value _
				& chr(10) & rs("business_city").value _
				& "," & rs("business_State").value & " " & rs("business_Zip").value _
				& "," & rs("business_Country").value & chr(10) 
		End If
		
		If Not IsNull(rs("business_phone")) And Trim(rs("business_phone")) <> "" Then
	        temp_info = temp_info & "Tel:" & rs("business_phone") & " "
	    End If
	    If Not IsNull(rs("business_fax")) And Trim(rs("business_fax")) <> "" Then
	        temp_info = temp_info & "Fax:" & rs("business_fax") & " "
	    End If
	    tempTable.Add "info", formatString(temp_info)
		tempTable.Add "class", rs("class_code").value
        tempTable.Add "address2", rs("business_address2").value
		returnList.Add tempTable
		rs.MoveNext
	Loop
	
	rs.Close
	Set rs = Nothing
	
    Set get_carrier_list = returnList
End Function

'------------------------ removing double quote ------------------------------------------------------

Function formatString(arg)
    Dim temp
    If IsNull(arg) Or Trim(arg) = "" Then
        temp = ""
    Else
        temp = Replace(arg,chr(34)," ")
        temp = Replace(temp,chr(39),chr(42))
    End If
    formatString = temp
End Function
%>