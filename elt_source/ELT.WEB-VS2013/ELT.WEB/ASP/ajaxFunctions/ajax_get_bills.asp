<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_data_manager.inc" -->
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
	
    Dim search_type,search_no,export_type,import_type,dataObj,mode,search_list,qStr,topNum,cursorStr,domestic
    
    search_type = checkBlank(Request.QueryString("type"),"")
    search_no = checkBlank(Request.QueryString("no"),"")
    export_type = checkBlank(Request.QueryString("export"),"")
    import_type = checkBlank(Request.QueryString("import"),"")
    mode = checkBlank(Request.QueryString("mode"),"")
    qStr = checkBlank(Request.QueryString("qStr"),"")
    topNum = checkBlank("TOP " & Request.QueryString("limit"),"")
    cursorStr = checkBlank(Request.QueryString("cursor"),"")
    domestic = checkBlank(Request.QueryString("domestic"),"N")
    
    if mode = "list" Then
        If search_type = "house" Then
            If export_type <> "" Then
                Set search_list = get_export_HAWB_list()
            Elseif import_type <> "" Then
                Set search_list = get_import_HAWB_list()
            End If
        Elseif search_type = "master" Then
            If export_type <> "" Then
                Set search_list = get_export_MAWB_list()
            Elseif import_type <> "" Then
                Set search_list = get_import_MAWB_list()
            End If
        Elseif search_type = "file" Then
            If export_type <> "" Then
                Set search_list = get_export_File_list()
            Elseif import_type <> "" Then
                Set search_list = get_import_File_list()
            End If
        Else
        End If
        Call write_import_xml()
    Else
	End If
	
	eltConn.Close
	Set eltConn = Nothing
	
	Function get_export_HAWB_list()
        Dim tempList,SQL,rs
        Set rs = Server.CreateObject("ADODB.Recordset")
	    Set tempList = Server.CreateObject("System.Collections.ArrayList")
	    
	    If export_type = "A" Then
	        SQL = "SELECT DISTINCT " & topNum & " hawb_num FROM HAWB_master where elt_account_number=" _
		        & elt_account_number & " AND hawb_num LIKE N'" & qStr & "%' AND hawb_num>=N'" _
		        & cursorStr & "' and is_dome='" & domestic & "' ORDER BY hawb_num"
		Else
		    SQL = "SELECT DISTINCT " & topNum & " hbol_num FROM hbol_master where elt_account_number=" _
		        & elt_account_number & " AND hbol_num LIKE N'" & qStr & "%' AND hbol_num>=N'" _
		        & cursorStr & "' ORDER BY hbol_num"
		End If
		
        rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly,adLockReadOnly,adCmdText
	    Set rs.activeConnection = Nothing
	    
	    Do While Not rs.eof And Not rs.bof 
		    tempList.Add rs(0).value
		    rs.MoveNext
	    Loop
	    rs.Close
                
        Set get_export_HAWB_list = tempList
    End Function
    
    Function get_import_HAWB_list()
        Dim tempList,SQL,rs
        Set rs = Server.CreateObject("ADODB.Recordset")
	    Set tempList = Server.CreateObject("System.Collections.ArrayList")
	    
        SQL = "SELECT " & topNum & " hawb_num+' ('+mawb_num+')' FROM import_hawb where elt_account_number=" _
            & elt_account_number & " AND hawb_num LIKE N'" & qStr & "%' AND hawb_num>=N'" _
            & cursorStr & "' AND iType=N'" & import_type & "' GROUP by mawb_num,hawb_num ORDER BY mawb_num, hawb_num"

        
        rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly,adLockReadOnly,adCmdText
	    Set rs.activeConnection = Nothing
	    
	    Do While Not rs.eof And Not rs.bof 
		    tempList.Add rs(0).value
		    rs.MoveNext
	    Loop
	    rs.Close
                
        Set get_import_HAWB_list = tempList
    End Function
    
    Function get_export_MAWB_list()
        Dim tempList,SQL,rs
        Set rs = Server.CreateObject("ADODB.Recordset")
	    Set tempList = Server.CreateObject("System.Collections.ArrayList")
	    
	    If export_type = "A" Then
	        SQL = "SELECT DISTINCT " & topNum & " mawb_num FROM MAWB_master a "_
	            & "left outer join MAWB_NUMBER b ON "_
	            & "(a.mawb_num=b.mawb_no and a.elt_account_number=b.elt_account_number) " _
	            & "where a.elt_account_number=" & elt_account_number & " and b.Status!='C' " _
	            & "AND mawb_num LIKE N'" & qStr & "%' AND a.mawb_num>=N'" _
		        & cursorStr & "' and a.is_dome='" & domestic & "' AND ISNULL(mawb_num,'')<>''ORDER BY mawb_num"
	    Else
            SQL = "SELECT DISTINCT " & topNum & " a.booking_num FROM mbol_master a LEFT OUTER JOIN " _
		        & "ocean_booking_number b ON (a.booking_num=b.booking_num AND " _
		        & "a.elt_account_number=b.elt_account_number) " _
		        & "where a.elt_account_number=" & elt_account_number & " AND b.status!='C' " _
		        & "AND a.booking_num LIKE N'" & qStr & "%' AND a.booking_num>=N'" _
		        & cursorStr & "' AND ISNULL(a.booking_num,'')<>'' ORDER BY a.booking_num"
		    
		    '// Chnaged upon KAS VIETNAM     
		    SQL = "SELECT DISTINCT " & topNum & " booking_num FROM ocean_booking_number " _
		        & "WHERE elt_account_number=" & elt_account_number & " AND status!='C' " _
		        & "AND booking_num LIKE N'" & qStr & "%' AND booking_num>=N'" _
		        & cursorStr & "' AND ISNULL(booking_num,'')<>'' ORDER BY booking_num"
	    
	    End If

        
        rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly,adLockReadOnly,adCmdText
	    Set rs.activeConnection = Nothing

	    Do While Not rs.eof And Not rs.bof 
		    tempList.Add rs(0).value
		    rs.MoveNext
	    Loop
	    rs.Close
                
        Set get_export_MAWB_list = tempList
    End Function
    
    Function get_import_MAWB_list()
        Dim tempList,SQL,rs
        Set rs = Server.CreateObject("ADODB.Recordset")
	    Set tempList = Server.CreateObject("System.Collections.ArrayList")
	    
        SQL = "SELECT " & topNum & " mawb_num FROM import_mawb where elt_account_number=" _
            & elt_account_number & " AND mawb_num LIKE N'" & qStr & "%' AND mawb_num>=N'" _
            & cursorStr & "' AND iType=N'" & import_type & "' AND ISNULL(mawb_num,'')<>'' GROUP by mawb_num ORDER BY mawb_num"

        
        rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly,adLockReadOnly,adCmdText
	    Set rs.activeConnection = Nothing
	    
	    Do While Not rs.eof And Not rs.bof 
		    tempList.Add rs(0).value
		    rs.MoveNext
	    Loop
	    rs.Close
                
        Set get_import_MAWB_list = tempList
    End Function
    
    Function get_export_File_list()
        Dim tempList,SQL,rs
        Set rs = Server.CreateObject("ADODB.Recordset")
	    Set tempList = Server.CreateObject("System.Collections.ArrayList")
	    
	    If export_type = "A" Then
	        SQL = "SELECT DISTINCT " & topNum & " b.file# FROM MAWB_master a "_
	            & "left outer join MAWB_NUMBER b ON "_
	            & "(a.mawb_num=b.mawb_no and a.elt_account_number=b.elt_account_number) " _
	            & "where a.elt_account_number=" & elt_account_number & " and b.Status!='C' " _
	            & "AND b.file# LIKE N'" & qStr & "%' AND b.file#>=N'" _
		        & cursorStr & "' and a.is_dome='" & domestic & "' AND ISNULL(b.file#,'')<>'' ORDER BY b.file#"
	    Else
            SQL = "SELECT DISTINCT " & topNum & " b.file_no FROM mbol_master a LEFT OUTER JOIN " _
		        & "ocean_booking_number b ON (a.booking_num=b.booking_num AND " _
		        & "a.elt_account_number=b.elt_account_number) " _
		        & "where a.elt_account_number=" & elt_account_number & " AND b.status!='C' " _
		        & "AND b.file_no LIKE N'" & qStr & "%' AND b.file_no>=N'" _
		        & cursorStr & "' AND ISNULL(b.file_no,'')<>'' AND ISNULL(b.file_no,'')<>'' ORDER BY b.file_no"
		        
	    End If
        
        rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly,adLockReadOnly,adCmdText
	    Set rs.activeConnection = Nothing

	    Do While Not rs.eof And Not rs.bof 
		    tempList.Add rs(0).value
		    rs.MoveNext
	    Loop
	    rs.Close
                
        Set get_export_File_list = tempList
    End Function
    
    Function get_import_File_list()
        Dim tempList,SQL,rs
        Set rs = Server.CreateObject("ADODB.Recordset")
	    Set tempList = Server.CreateObject("System.Collections.ArrayList")
	    
        SQL = "SELECT " & topNum & " file_no FROM import_mawb where elt_account_number=" _
            & elt_account_number & " AND file_no LIKE N'" & qStr & "%' AND file_no>=N'" _
            & cursorStr & "' AND iType=N'" & import_type & "' AND ISNULL(file_no,'')<>'' GROUP by file_no ORDER BY file_no"

        
        rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly,adLockReadOnly,adCmdText
	    Set rs.activeConnection = Nothing
	    
	    Do While Not rs.eof And Not rs.bof 
		    tempList.Add rs(0).value
		    rs.MoveNext
	    Loop
	    rs.Close
                
        Set get_import_File_list = tempList
    End Function
    
    Function get_export_MAWB_Only_list()
        Dim tempList,SQL,rs
        Set rs = Server.CreateObject("ADODB.Recordset")
	    Set tempList = Server.CreateObject("System.Collections.ArrayList")
	    
	    If export_type = "A" Then
	        SQL = "SELECT DISTINCT " & topNum & " mawb_num FROM MAWB_master a "_
	            & "left outer join MAWB_NUMBER b ON "_
	            & "(a.mawb_num=b.mawb_no and a.elt_account_number=b.elt_account_number) " _
	            & "where mawb_num NOT IN (SELECT isnull(mawb_num,'') from HAWB_MASTER where " _
	            & "elt_account_number=" & elt_account_number & ") and " _
	            & "a.elt_account_number=" & elt_account_number & " and b.Status!='C' " _
	            & "AND mawb_num LIKE N'" & qStr & "%' AND a.mawb_num>=N'" _
		        & cursorStr & "' and a.is_dome='" & domestic & "' AND ISNULL(mawb_num,'')<>'' ORDER BY mawb_num"
	    Else
            SQL = "SELECT DISTINCT " & topNum & " a.booking_num FROM mbol_master a LEFT OUTER JOIN " _
		        & "ocean_booking_number b ON (a.booking_num=b.booking_num AND " _
		        & "a.elt_account_number=b.elt_account_number) " _
		        & "where a.booking_num NOT IN (SELECT isnull(booking_num,'') from hbol_master where " _
		        & "elt_account_number=" & elt_account_number & ") and " _
		        & "a.elt_account_number=" & elt_account_number & " AND status!='C' " _
		        & "AND a.booking_num LIKE N'" & qStr & "%' AND a.booking_num>=N'" _
		        & cursorStr & "' AND ISNULL(a.booking_num,'')<>'' ORDER BY a.booking_num"
	    End If
        
        rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly,adLockReadOnly,adCmdText
	    Set rs.activeConnection = Nothing

	    Do While Not rs.eof And Not rs.bof 
		    tempList.Add rs(0).value
		    rs.MoveNext
	    Loop
	    rs.Close
                
        Set get_export_MAWB_Only_list = tempList
    End Function
    
    
    Sub write_import_xml()
        Dim i
        Response.Expires = 0  
        Response.AddHeader "Pragma","no-cache"  
        Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
        Response.ContentType = "text/xml"
        Response.CharSet = "utf-8"
        
        Response.Write "<?xml version=""1.0"" encoding=""utf-8""?>"
        Response.Write "<FormDocument>"
        
        If search_type <> "none" Then
            If Not IsNull(search_list) And Not IsEmpty(search_list) Then
                For i=0 To search_list.count-1
                Response.Write "<item>"
                Response.Write "<value>" & encodeXMLCode(search_list(i)) & "</value>"
                Response.Write "<label>" & encodeXMLCode(search_list(i)) & "</label>"
                Response.Write "</item>"
                Next
            End If
            Response.Write "</FormDocument>"
        Else
            If Not IsNull(search_list) And Not IsEmpty(search_list) Then
                For i=0 To search_list.count-1
                Response.Write "<item>"
                Response.Write "<value>" & encodeXMLCode(search_list(i)) & "</value>"
                Response.Write "<label>" & encodeXMLCode(search_list(i)) & "</label>"
                Response.Write "</item>"
                Next
            End If
            Response.Write "</FormDocument>"
        End If
    End Sub
    
%>