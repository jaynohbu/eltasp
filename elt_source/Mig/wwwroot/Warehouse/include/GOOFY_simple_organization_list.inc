<%

'///////////////////////////////////////////////////////////////////////////////////////////////////////
'//  
'//  Created By Joon Park On Mar-05-2007
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

Public ShipperList,ConsigneeList,AgentList,TruckerList,CarrierList,GovernList


Sub make_organization_list(elt_account_number)

    Set ShipperList = Server.CreateObject("System.Collections.ArrayList")
    Set ShipperList = get_organization_list(elt_account_number,"Shipper")
    Set ConsigneeList = Server.CreateObject("System.Collections.ArrayList")
    Set ConsigneeList = get_organization_list(elt_account_number,"Consignee")
    Set AgentList = Server.CreateObject("System.Collections.ArrayList")
    Set AgentList = get_organization_list(elt_account_number,"Agent")
    Set TruckerList = Server.CreateObject("System.Collections.ArrayList")
    Set TruckerList = get_organization_list(elt_account_number,"Trucker")
    Set CarrierList = Server.CreateObject("System.Collections.ArrayList")
    Set CarrierList = get_organization_list(elt_account_number,"Carrier")
    Set GovernList = Server.CreateObject("System.Collections.ArrayList")
    Set GovernList = get_organization_list(elt_account_number,"Government")
    
End Sub

'----------------------- Set Shipper List -----------------------------------------------------

Function get_organization_list(elt_account_number,org_type)
    Dim returnList,tempTable,SQL,rs
    
    Set returnList = Server.CreateObject("System.Collections.ArrayList")
    Set tempTable = Server.CreateObject("System.Collections.HashTable")
    Set rs = Server.CreateObject("ADODB.Recordset")
    
    SQL = "SELECT org_account_number,ISNULL(dba_name,'') as dba_name," _
        & "RTRIM(ISNULL(class_code,'')) as class_code FROM organization " _
        & "WHERE elt_account_number = "& elt_account_number 
        
    Select case org_type
        case "Shipper" 
            SQL = SQL & "AND is_shipper='Y' "
        case "Consignee" 
            SQL = SQL & "AND (is_consignee='Y' OR is_shipper='Y') "
        case "Carrier" 
            SQL = SQL & "AND is_carrier='Y' AND ISNULL(carrier_code,'') <> '' "
        case "Agent" 
            SQL = SQL & "AND is_agent='Y' "
        case "Trucker" 
            SQL = SQL & "AND z_is_trucker='Y' "
        case "Government"
            SQL = SQL & "AND z_is_govt='Y' "
    End Select
        
    SQL = SQL & " ORDER BY dba_name"
    eltConn.CursorLocation = adUseClient
	rs.CursorLocation = adUseClient	
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
	'// rs.Open SQL,eltConn,adOpenStatic,adLockBatchOptimistic,adCmdText
    Set rs.ActiveConnection = Nothing

    Do While Not rs.EOF and NOT rs.bof
        Set tempTable = Server.CreateObject("System.Collections.HashTable")
        tempTable.Add "acct", rs("org_account_number").value
        If rs("class_code").value <> "" Then
            tempTable.Add "name", RemoveQuotations(rs("dba_name").value & " - " & rs("class_code").value)
        Else
            tempTable.Add "name", RemoveQuotations(rs("dba_name").value)
        End If
        returnList.Add tempTable
		rs.MoveNext
	Loop
    
    rs.Close
	Set rs = Nothing
    Set get_organization_list = returnList
End Function


Function RemoveQuotations(arg)
    Dim temp
    If IsNull(arg) Or Trim(arg) = "" Then
        temp = ""
    Else
        temp = Replace(arg,chr(34)," ")
        temp = Replace(temp,chr(39),chr(42))
    End If
    RemoveQuotations = temp
End Function
%>