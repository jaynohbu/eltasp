<%

'///////////////////////////////////////////////////////////////////////////////////////////////////////
'//  
'//  Created By Joon Park On Dec-8-2006
'//
'//  This file can be included in other asp pages when organization list is needed
'//  shipper,consignee,agent,trucker,carrier for now (can be added later)
'//  make_organization_list function creates all of them at once (tabes elt account number as parameter)
'//
'//  Usage: 
'//     1) Call make_billing_list("80002000")  
'//     2) Set hawb_list = get_HAWB_list("80002000") etc.
'// 
'//  Returns:
'//     Each list is ArrayList Object
'//     All list contains billing number
'//
'//  Remarks:
'//     ...OnlyList contains billing list that doesn't have house bills
'//
'//  Hope this will help U guys... Thnx to Joon  ^_____________________^
'//
'///////////////////////////////////////////////////////////////////////////////////////////////////////


Public HAWBList, MAWBList, MAWBOnlyList
Public HBOLList, BookingList, BookingOnlyList

Sub make_billing_list(elt_num)
    
    Set HAWBList = get_HAWB_list(elt_num)
    Set MAWBList = get_MAWB_list(elt_num)
    Set MAWBOnlyList = get_MAWB_only_list(elt_num)
    Set HBOLList = get_HBOL_list(elt_num)
    Set BookingList = get_Booking_list(elt_num)
    Set BookingOnlyList = get_Booking_Only_list(elt_num)

End Sub

Function get_HAWB_list(elt_num)

    Dim tempList,SQL,rs
    Set rs = Server.CreateObject("ADODB.Recordset")
	Set tempList = Server.CreateObject("System.Collections.ArrayList")
	SQL = "SELECT hawb_num FROM HAWB_master where elt_account_number=" _
		& elt_num & " ORDER BY hawb_num"
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

	Do While Not rs.eof And Not rs.bof 
		tempList.Add rs("hawb_num").value
		rs.MoveNext
	Loop
	rs.Close
            
    Set get_HAWB_list = tempList
    
End Function

Function get_MAWB_list(elt_num)

    Dim tempList,SQL,rs
    Set rs = Server.CreateObject("ADODB.Recordset")
	Set tempList = Server.CreateObject("System.Collections.ArrayList")
	SQL = "SELECT mawb_num FROM MAWB_master where elt_account_number=" _
		& elt_num & " ORDER BY mawb_num"
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

	Do While Not rs.eof And Not rs.bof 
		tempList.Add rs("mawb_num").value
		rs.MoveNext
	Loop
	rs.Close

    Set get_MAWB_list = tempList
    
End Function

Function get_MAWB_only_list(elt_num)

    Dim tempList,SQL,rs
    Set rs = Server.CreateObject("ADODB.Recordset")
	Set tempList = Server.CreateObject("System.Collections.ArrayList")
	SQL = "SELECT DISTINCT mawb_num FROM MAWB_master a "_
	    & "left outer join MAWB_NUMBER b ON "_
	    & "(a.mawb_num=b.mawb_no and a.elt_account_number=b.elt_account_number) " _
	    & "where mawb_num NOT IN (SELECT isnull(mawb_num,'') from HAWB_MASTER where " _
	    & "elt_account_number=" & elt_num & ") and " _
	    & "a.elt_account_number=" & elt_num & " and b.Status!='C' " _
	    & "ORDER BY mawb_num"
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

	Do While Not rs.eof And Not rs.bof 
		tempList.Add rs("mawb_num").value
		rs.MoveNext
	Loop
	rs.Close

    Set get_MAWB_only_list = tempList
    
End Function

Function get_HBOL_list(elt_num)

    Dim tempList,SQL,rs
    Set rs = Server.CreateObject("ADODB.Recordset")
	Set tempList = Server.CreateObject("System.Collections.ArrayList")
	SQL = "SELECT hbol_num FROM hbol_master where elt_account_number=" _
		& elt_num & " ORDER BY hbol_num"
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

	Do While Not rs.eof And Not rs.bof 
		tempList.Add rs("hbol_num").value
		rs.MoveNext
	Loop
	rs.Close
	
	Set get_HBOL_list = tempList
	
End Function

Function get_Booking_list(elt_num)

    Dim tempList,SQL,rs
    Set rs = Server.CreateObject("ADODB.Recordset")
	Set tempList = Server.CreateObject("System.Collections.ArrayList")
	SQL = "SELECT booking_num FROM mbol_master where elt_account_number=" _
		& elt_num & " ORDER BY booking_num"
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

	Do While Not rs.eof And Not rs.bof 
		tempList.Add rs("booking_num").value
		rs.MoveNext
	Loop
	rs.Close
	
	Set get_Booking_list = tempList
	
End Function

Function get_Booking_Only_list(elt_num)

    Dim tempList,SQL,rs
    Set rs = Server.CreateObject("ADODB.Recordset")
	Set tempList = Server.CreateObject("System.Collections.ArrayList")
	SQL = "SELECT DISTINCT a.booking_num FROM mbol_master a LEFT OUTER JOIN " _
		& "ocean_booking_number b ON (a.booking_num=b.booking_num AND " _
		& "a.elt_account_number=b.elt_account_number) " _
		& "where a.booking_num NOT IN (SELECT isnull(booking_num,'') from hbol_master where " _
		& "elt_account_number=" & elt_num & ") and " _
		& "a.elt_account_number=" & elt_num & " and status!='C'"
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

	Do While Not rs.eof And Not rs.bof 
		tempList.Add rs("booking_num").value
		rs.MoveNext
	Loop
	rs.Close
	
	Set get_Booking_Only_list = tempList
	
End Function


Function get_HBOL_list_booked(elt_num)

    Dim tempList,SQL,rs
    Set rs = Server.CreateObject("ADODB.Recordset")
	Set tempList = Server.CreateObject("System.Collections.ArrayList")
	SQL = "SELECT a.hbol_num FROM hbol_master a, ocean_booking_number b where " _
	    & "a.booking_num = b.booking_num and a.elt_account_number = b.elt_account_number "_
	    & "AND ISNULL(b.status,'') = 'B' AND a.elt_account_number=" & elt_num & " ORDER BY hbol_num"
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

	Do While Not rs.eof And Not rs.bof 
		tempList.Add rs("hbol_num").value
		rs.MoveNext
	Loop
	rs.Close
	
	Set get_HBOL_list_booked = tempList
	
End Function

Function get_HAWB_list_booked(elt_num)

    Dim tempList,SQL,rs
    Set rs = Server.CreateObject("ADODB.Recordset")
	Set tempList = Server.CreateObject("System.Collections.ArrayList")
	SQL = "SELECT a.hawb_num FROM HAWB_master a, mawb_number b where " _
	    & "a.mawb_num = b.mawb_no AND a.elt_account_number=b.elt_account_number " _
		& "AND ISNULL(b.status,'') = 'B' AND a.elt_account_number=" & elt_num & " ORDER BY hawb_num"
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

	Do While Not rs.eof And Not rs.bof 
		tempList.Add rs("hawb_num").value
		rs.MoveNext
	Loop
	rs.Close
            
    Set get_HAWB_list_booked = tempList
    
End Function

%>