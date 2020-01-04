<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_data_manager.inc" -->
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
	
    Dim search_type,search_no,dataObj,mode,qStr,topNum,cursorStr,error_code,po_num
    
    search_type = checkBlank(Request.QueryString("type"),"")
    search_no = checkBlank(Request.QueryString("no"),-1)
    mode = checkBlank(Request.QueryString("mode"),"")
    qStr = checkBlank(Request.QueryString("qStr"),"")
    topNum = checkBlank("TOP " & Request.QueryString("limit"),"")
    cursorStr = checkBlank(Request.QueryString("cursor"),"")
    error_code = 0
    
    If mode = "view" Then
        Call get_all_info()
    Elseif mode = "list" Then
        Call get_the_list()
    Elseif mode = "update" Then
        Call save_to_table()
        Call save_response()
    Elseif mode = "delete" And search_no <> "" And search_no > 0 Then
        Call delete_from_table()
    Else
    
    End If
    
    eltConn.Close()
    Set eltConn = Nothing

    Sub get_all_info()
    
        Dim SQL,dataTable

        SQL = "SELECT TOP 1 * FROM booking_confirm WHERE elt_account_number=" & elt_account_number _
			    & " AND auto_uid=N'" & search_no & "' ORDER BY auto_uid DESC"

        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set dataTable = dataObj.GetRowTable(0)

        If search_no < 0  Then
            search_no = ""
        End If
        
        Response.Expires = 0  
        Response.AddHeader "Pragma","no-cache"  
        Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
        Response.ContentType = "text/xml"
        Response.CharSet = "utf-8"
        Response.Write "<?xml version=""1.0"" encoding=""utf-8""?>"
        Response.Write "<FormDocument>"
        Response.Write "<Search_Mode>" & encodeXMLCode(search_type) & "</Search_Mode>"
        Response.Write "<Search_Num>" & encodeXMLCode(search_no) & "</Search_Num>"
        Response.Write "</FormDocument>"
        
    End Sub
    
    
    Sub get_the_list()
        Dim SQL,rs, vNextNum
        
        SQL = "SELECT DISTINCT " & topNum & " auto_uid,bc_no FROM booking_confirm WHERE elt_account_number=" _
            & elt_account_number & " AND bc_no like N'" & qStr & "%'"
        If cursorStr <> "" Then
            SQL = SQL & " AND auto_uid>(select auto_uid from booking_confirm b where b.elt_account_number=elt_account_number and CAST(bc_no as NVARCHAR)=N'" & cursorStr & "') "
        End If    
        
        SQL = SQL & " order by auto_uid"

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
            Response.Write "<value>" & rs("auto_uid").value & "</value>"
            Response.Write "<label>" & rs("bc_no").value & "</label>"
            Response.Write "</item>"
            rs.MoveNext
	    Loop
        Response.Write "</FormDocument>"
        rs.Close()

    End Sub
    
    Function IsEmptyRS(sqltxt)
        Dim returnVal,rs
        
        returnVal = False
        Set rs = Server.CreateObject("ADODB.Recordset")
        rs.Open sqltxt,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

        If rs.EOF Or rs.BOF Then
            returnVal = True
        End If
        IsEmptyRS = returnVal
        rs.close
    End Function
    
%>
