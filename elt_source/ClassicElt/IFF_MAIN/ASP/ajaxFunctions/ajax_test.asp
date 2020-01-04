<%@ transaction=supported language="vbscript" codepage="65001" %>
<% Option Explicit %>
<% Response.CharSet = "UTF-8" %>
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

    eltConn.BeginTrans
    
    If request.QueryString("mode") = "save" Then
        save_dumb_values()
        save_all_info()
    Else
        get_all_info()
    End If
    
    eltConn.CommitTrans
    
    Sub save_dumb_values
        Dim rs,SQL
        Set rs=Server.CreateObject("ADODB.Recordset")
        
        SQL = "SELECT * FROM test_table"
        rs.Open SQL,eltConn,adOpenStatic,adLockPessimistic,adCmdText
        
        If rs.EOF Or rs.BOF Then
            rs.AddNew
        End If
        
        rs("value1") = "test"
        rs("value2") = "test"
        rs.Update
        rs.Close
    End Sub
    
    Sub save_all_info()
        Dim SQL,dataTable,dataObj,rs
        
        Set dataObj = new DataManager
        Set dataTable = Server.CreateObject("System.Collections.HashTable")
    
        dataTable.Add "value1", Request.Form("value1").Item
        dataTable.Add "value2", Request.Form("value2").Item
        Call dataObj.SetColumnKeys("test_table")
        Call dataObj.UpdateDBRow("SELECT * FROM test_table", dataTable)
    End Sub
    
    Sub get_all_info()
        Dim SQL,dataTable,dataObj,rs
        
        SQL = "SELECT * FROM test_table"
        
        Set dataObj = new DataManager
        Set dataTable = Server.CreateObject("System.Collections.HashTable")
        
        dataObj.SetDataList(SQL)
        Set dataTable = dataObj.GetRowTable(0)

        Response.Expires = 0  
        Response.AddHeader "Pragma","no-cache"  
        Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
        Response.ContentType = "text/xml"
        Response.CharSet = "UTF-8"
        Response.Write "<?xml version=""1.0"" encoding=""utf-8""?>"
        Response.Write "<FormDocument>"
        If dataObj.DataList.Count > 0 Then
            Response.Write("<value1>" & dataTable("value1") & "</value1>")
            Response.Write("<value2>" & dataTable("value2") & "</value2>")
        End If
        Response.Write "</FormDocument>"
        
    End Sub
    

%>