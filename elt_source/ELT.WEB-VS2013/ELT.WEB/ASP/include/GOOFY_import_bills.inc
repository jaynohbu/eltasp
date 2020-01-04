<%

Public importHAWBList,importHBOLList

Sub make_import_billing_list(elt_num)

    Set importHAWBList = get_import_HAWB_list(elt_num)
    Set importHBOLList = get_import_HBOL_list(elt_num)

End Sub

Function get_import_HAWB_list(elt_num)

	Dim hawb_table,hawb_array,SQL,rs
	Set hawb_array = Server.CreateObject("System.Collections.ArrayList")

	SQL = "SELECT distinct a.hawb_num,a.mawb_num,a.sec FROM import_hawb a "_
		& "LEFT OUTER JOIN import_mawb b ON (a.mawb_num=b.mawb_num and " _
		& "a.elt_account_number=b.elt_account_number) "_
		& "WHERE a.elt_account_number='" & elt_account_number & "' AND " _
		& "a.iType='A' ORDER BY hawb_num"
	Set rs = eltConn.execute(SQL)

	Do While Not rs.EOF and NOT rs.bof

		Set hawb_table = Server.CreateObject("System.Collections.HashTable")
		hawb_table.Add "key", checkBlank(rs("hawb_num").value,"Anonymous") _
		    & " (" & rs("mawb_num").value & ")"
		hawb_table.Add "hawb", checkBlank(rs("hawb_num").value,"")
		hawb_table.Add "mawb", rs("mawb_num").value
		hawb_table.Add "sec", rs("sec").value
		rs.MoveNext
		hawb_array.Add hawb_table
	Loop
    rs.Close
    
    Set get_import_HAWB_list = hawb_array
    
End Function


Function get_import_HBOL_list(elt_num)

	Dim hawb_table,hawb_array,SQL,rs
	Set hawb_array = Server.CreateObject("System.Collections.ArrayList")

	SQL = "SELECT distinct a.hawb_num,a.mawb_num,a.sec FROM import_hawb a "_
		& "LEFT OUTER JOIN import_mawb b ON (a.mawb_num=b.mawb_num and " _
		& "a.elt_account_number=b.elt_account_number) "_
		& "WHERE a.elt_account_number='" & elt_account_number & "' AND " _
		& "a.iType='O' ORDER BY hawb_num"
	Set rs = eltConn.execute(SQL)

	Do While Not rs.EOF and NOT rs.bof

		Set hawb_table = Server.CreateObject("System.Collections.HashTable")
		hawb_table.Add "key", checkBlank(rs("hawb_num").value,"Anonymous") _
		    & " (" & rs("mawb_num").value & ")"
		hawb_table.Add "hawb", checkBlank(rs("hawb_num").value,"")
		hawb_table.Add "mawb", rs("mawb_num").value
		hawb_table.Add "sec", rs("sec").value
		rs.MoveNext
		hawb_array.Add hawb_table
	Loop
	rs.Close
	
	Set get_import_HBOL_list = hawb_array
	
End Function



%>