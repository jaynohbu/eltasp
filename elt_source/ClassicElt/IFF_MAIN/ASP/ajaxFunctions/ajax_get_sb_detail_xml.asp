<!--  #INCLUDE FILE="../Include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../Include/connection.asp" -->
<!--  #INCLUDE FILE="../Include/GOOFY_Util_fun.inc" -->
<!--  #INCLUDE FILE="../Include/GOOFY_data_manager.inc" -->
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
	
	Dim scheB

	Call GetParameters
	Call GetAllInfo
	
	eltConn.Close()
    Set eltConn = Nothing
	
	Sub GetParameters
	    scheB = checkBlank(Request.QueryString("scheB"),0)
	End Sub
	
	Sub GetAllInfo
	
	    Dim SQL,dataTable,dataObj
	    
	    SQL = "SELECT sb,sb_unit1,sb_unit2,description,export_code,license_type,eccn FROM scheduleb " _
	        & "WHERE elt_account_number=" & elt_account_number & " AND sb=N'" & scheB & "'"
	    
	    Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set dataTable = dataObj.GetRowTable(0)
        
        Response.Expires = 0  
        Response.AddHeader "Pragma","no-cache"  
        Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
        Response.ContentType = "text/xml"
        Response.CharSet = "utf-8"
        Response.Write "<?xml version=""1.0"" encoding=""utf-8""?>"
        Response.Write "<FormDocument>"
        
        If dataObj.DataList.Count > 0 Then
            Response.Write(MakeXMLString(dataTable,dataObj.GetKeyArray()))
        End If
        
        Response.Write "</FormDocument>"
        
	End Sub
%>