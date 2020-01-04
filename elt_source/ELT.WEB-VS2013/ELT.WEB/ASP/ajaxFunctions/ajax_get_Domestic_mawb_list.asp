<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_util_fun.inc" -->

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
	If mode = "DGB" Then
	    Call get_list_dome_mt_status("Y","DG","B")
    ElseIf mode = "DAB" Then
	    Call get_list_dome_mt_status("Y","DA","B")
	Elseif mode = "DUB" Then
	    Call get_list_dome_mt_status("Y","","B")
	End If
	
    Sub get_list_dome_mt_status(is_dome,master_type,status)
        Dim SQL,rs
        
        If master_type = "" Then
            SQL = "select " & topNum & " mawb_no from mawb_number where elt_account_number = " _
                & elt_account_number & " and is_dome=N'" & is_dome _
                & "' and status=N'" & status & "' and mawb_no like N'" & qStr & "%' and mawb_no >=N'" _
                & cursorStr & "'order by mawb_no"
        Else
            SQL = "select " & topNum & " mawb_no from mawb_number where elt_account_number = " _
                & elt_account_number & " and is_dome=N'" & is_dome _
                & "' and status=N'" & status & "' and isnull(master_type,'DA')=N'" _
                & master_type & "' and mawb_no like N'" & qStr & "%' and mawb_no >=N'" _
                & cursorStr & "'order by mawb_no"

        End If
        

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
	
%>