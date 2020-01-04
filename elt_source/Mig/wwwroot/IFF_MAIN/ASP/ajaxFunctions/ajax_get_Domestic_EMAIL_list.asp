<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_util_fun.inc" -->

<%    
    
    Dim elt_account_number,login_name,user_id,ClientOS,session_ip,session_IntIp,Filename,OrgNo
    Dim session_server_name,session_user_lname,Email,redPage,valueX
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
	FileName = checkBlank(Request.QueryString("Filename"),"")
	OrgNo = checkBlank(Request.QueryString("OrgNo"),"")
	Email= checkBlank(Request.QueryString("Email"),"")
	valueX = checkBlank(Request.QueryString("Value"),"")

    
	If mode = "HAWB" Then
	    Call get_list_dome_HAWB()
	Elseif mode = "checkbox" then
	    CALL CHECKBOXSELECT()
    ElseIf mode = "MAWB" Then
	    Call get_list_dome_MAWB()
	Elseif mode = "FILE" Then
	    Call get_list_dome_FILE()
	Elseif mode = "UPDATE" Then
	    Call get_update_email()
    Elseif mode = "Usermailupdate" Then
	    Call get_mailupdate_email()

	End If
	
	
	
    Sub get_update_email()
        Dim SQL,rs
            SQL= "UPDATE organization set owner_email='"&Email&"' where elt_account_number= "
        SQL= SQL& elt_account_number & " and org_account_number=N'"& OrgNo & "'"
        Set rs = Server.CreateObject("ADODB.RecordSet")
        Set rs = eltConn.execute(SQL)
	End Sub
	
	Sub CHECKBOXSELECT()
        Dim SQL,rs

        SQL= "UPDATE user_files set file_checked=N'" & valueX & "' where elt_account_number=" 
        SQL= SQL & elt_account_number & " and org_no=N'"& OrgNo & "' and file_name=N'"& FileName & "'" 
        Set rs = Server.CreateObject("ADODB.RecordSet")
        Set rs = eltConn.execute(SQL)
	End Sub
	
	Sub get_mailupdate_email()
        Dim SQL,rs
            SQL= "UPDATE Users set user_email=N'"&Email&"' where elt_account_number= "
        SQL= SQL& elt_account_number & " and userid=N'"& user_id & "'"
        Set rs = Server.CreateObject("ADODB.RecordSet")
        Set rs = eltConn.execute(SQL)
	End Sub
	
	Sub get_list_dome_FILE()
        Dim SQL,rs
            SQL = "select " & topNum & " isnull(b.file#,'') as file# from MAWB_master a left join MAWB_NUMBER b ON "_
                & " (a.mawb_num=b.mawb_no and a.elt_account_number=b.elt_account_number) "_
                & " where a.elt_account_number = " & elt_account_number & " and a.is_dome='Y' " _
                & " and b.status!='C'" _
                & " and b.file# like N'" & qStr & "%' and isnull(b.file#,'') >=' " _
                & cursorStr & "' and isnull(b.file#,'') != '' order by b.file#"

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
            Response.Write "<value>" & rs("file#").value & "</value>"
            Response.Write "<label>" & rs("file#").value & "</label>"
            Response.Write "</item>"
            rs.MoveNext
	    Loop
        Response.Write "</FormDocument>"
        rs.Close()
    End Sub
    
    Sub get_list_dome_HAWB()
        Dim SQL,rs
        
            SQL = "select " & topNum & "hawb_num FROM HAWB_master where elt_account_number=" _
                & elt_account_number & " and is_dome='Y'" _
                & " and isnull(shipper_account_number,0)<>0 "_
                & " and hawb_num like N'" & qStr & "%' and hawb_num >=N'" _
                & cursorStr & "'order by hawb_num"


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
            Response.Write "<value>" & rs("hawb_num").value & "</value>"
            Response.Write "<label>" & rs("hawb_num").value & "</label>"
            Response.Write "</item>"
            rs.MoveNext
	    Loop
        Response.Write "</FormDocument>"
        rs.Close()
    End Sub
    
    Sub get_list_dome_MAWB()
        Dim SQL,rs
            SQL = "select " & topNum & " a.mawb_num as mawb_num FROM MAWB_master a left outer join MAWB_NUMBER b " _
                & "ON (a.mawb_num=b.mawb_no and a.elt_account_number=b.elt_account_number) "_
                & "where a.elt_account_number=" & elt_account_number & " and a.is_dome='Y'" _
                & " and b.status !='C' " _
                & " and a.mawb_num like N'" & qStr & "%' and a.mawb_num >=N'" _
                & cursorStr & "'order by a.mawb_num"

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
    
    
%>