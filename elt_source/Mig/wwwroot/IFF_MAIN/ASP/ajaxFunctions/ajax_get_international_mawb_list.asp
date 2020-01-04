<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_util_fun.inc" -->

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
	
	Dim mode,qStr,topNum,cursorStr
	
	mode = checkBlank(Request.QueryString("mode"),"")
    qStr = checkBlank(Request.QueryString("qStr"),"")
	topNum = checkBlank("TOP " & Request.QueryString("limit"),"")
	cursorStr = checkBlank(Request.QueryString("cursor"),"")
	If mode = "OI" Then
	    Call get_list_import("O")
	ElseIf mode = "AE" Then
	    Call get_list_dome_AE("N","","B")
    ElseIf mode = "AI" Then
	    Call get_list_import("A")
	ElseIf mode = "OEB" Then
	    Call get_list_OEB()
	ElseIf mode = "OEM" Then
	    Call get_list_OEMA()
	End If
	
    Sub get_list_dome_AE(is_dome,master_type,status)
        Dim SQL,rs
        
        SQL = "select " & topNum & " mawb_no from mawb_number where elt_account_number=" _
            & elt_account_number & " and is_dome=N'" & is_dome _
            & "' and status='" & status & "' and mawb_no like N'" & qStr & "%' and mawb_no>=N'" _
            & cursorStr & "'order by mawb_no"

        

	    Set rs = Server.CreateObject("ADODB.Recordset")
	    rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing

        Response.Expires = 0  
        Response.AddHeader "Pragma","no-cache"  
        Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
        Response.ContentType = "text/xml"
        Response.CharSet = "utf-8"
        Response.Write "<?xml version=""1.0"" encoding=""utf-8""?>"
        Response.Write "<FormDocument>"
        
        Do While Not rs.EOF and NOT rs.bof
            Response.Write "<item>"
            Response.Write "<value>" & rs("mawb_no").value & "</value>"
            Response.Write "<label>" & rs("mawb_no").value & "</label>"
            Response.Write "</item>"
            rs.MoveNext
	    Loop
        Response.Write "</FormDocument>"
        rs.Close()
    End Sub
    
    
    
   Sub get_list_import(master_type)
        Dim SQL,rs
        
           SQL = "select distinct " & topNum & " mawb_num from import_mawb where elt_account_number= "_
            & elt_account_number & " and Len(mawb_num)> 0 and mawb_num like N'" & qStr & "%' and itype='" _
            & master_type & "' and mawb_num>=N'" & cursorStr & "' order by mawb_num"
        

	    Set rs = Server.CreateObject("ADODB.Recordset")
	    rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing

        Response.Expires = 0  
        Response.AddHeader "Pragma","no-cache"  
        Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
        Response.ContentType = "text/xml"
        Response.CharSet = "utf-8"
        Response.Write "<?xml version=""1.0"" encoding=""utf-8""?>"
        Response.Write "<FormDocument>"
        
        Do While Not rs.EOF and NOT rs.bof
            Response.Write "<item>"
            Response.Write "<value>" & rs("mawb_num").value & "</value>"
            Response.Write "<label>" & rs("mawb_num").value & "</label>"
            Response.Write "</item>"
            rs.MoveNext
	    Loop
        Response.Write "</FormDocument>"
        rs.Close()
    End Sub
	
	Sub get_list_OEMA()
        Dim SQL,rs
        
           SQL = "select distinct " & topNum & " mbol_num from ocean_booking_number where elt_account_number= "_
            & elt_account_number & " and len(mbol_num)>0 and mbol_num like N'" & qStr & "%' and booking_num>=N'" _
            & cursorStr & "' order by mbol_num"
   

	     Set rs = Server.CreateObject("ADODB.Recordset")
	    rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing

        Response.Expires = 0  
        Response.AddHeader "Pragma","no-cache"  
        Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
        Response.ContentType = "text/xml"
        Response.CharSet = "utf-8"
        Response.Write "<?xml version=""1.0"" encoding=""utf-8""?>"
        Response.Write "<FormDocument>"
        
        Do While Not rs.EOF and NOT rs.bof
            Response.Write "<item>"
            Response.Write "<value>" & rs("mbol_num").value & "</value>"
            Response.Write "<label>" & rs("mbol_num").value & "</label>"
            Response.Write "</item>"
            rs.MoveNext
	    Loop
        Response.Write "</FormDocument>"
        rs.Close()
    End Sub
	
	Sub get_list_OEB()
        Dim SQL,rs
        
        SQL = "select distinct " & topNum & " booking_num from ocean_booking_number where elt_account_number= "_
            & elt_account_number & "  and booking_num like N'" & qStr & "%' and booking_num>=N'" & cursorStr & "' order by booking_num"
        
        Set rs = Server.CreateObject("ADODB.Recordset")
	    rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing

        Response.Expires = 0  
        Response.AddHeader "Pragma","no-cache"  
        Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
        Response.ContentType = "text/xml"
        Response.CharSet = "utf-8"
        Response.Write "<?xml version=""1.0"" encoding=""utf-8""?>"
        Response.Write "<FormDocument>"
        
        Do While Not rs.EOF and NOT rs.bof
            Response.Write "<item>"
            Response.Write "<value>" & rs("booking_num").value & "</value>"
            Response.Write "<label>" & rs("booking_num").value & "</label>"
            Response.Write "</item>"
            rs.MoveNext
	    Loop
        Response.Write "</FormDocument>"
        rs.Close()
    End Sub


%>