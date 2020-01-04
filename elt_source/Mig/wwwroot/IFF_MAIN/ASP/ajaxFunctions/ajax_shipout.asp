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
	
	Dim mode,qStr,topNum,cursorStr,uid,wr_num,so_num
	
    mode = checkBlank(Request.QueryString("mode"),"")
    uid = checkBlank(Request.QueryString("uid"),-1)
    qStr = checkBlank(Request.QueryString("qStr"),"")
    topNum = checkBlank("TOP " & Request.QueryString("limit"),"")
    cursorStr = checkBlank(Request.QueryString("cursor"),"")
    
    If mode = "view" Then
        Call get_all_info()  
    Elseif mode = "list" Then
        Call get_search_list()
    Elseif mode = "list2" Then
        Call get_search_list2()
    Elseif mode = "delete" And uid <> "" Then
        Call delete_from_table()
    End If

    eltConn.Close()
    Set eltConn = Nothing
    
    '/////////////////////////////////////////////////////////////////////////////////
    

    
    Sub get_all_info()
        Dim SQL,dataTable,dataObj,rs,so_num
        
        SQL = "SELECT TOP 1 * FROM warehouse_shipout WHERE elt_account_number=" & elt_account_number _
        & " AND auto_uid=" & uid & " ORDER BY auto_uid DESC"

        
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
            Response.Write("<shipper_name>" & encodeXMLCode(GetBusinessName(dataTable("consignee_acct"))) & "</shipper_name>")
            Response.Write("<shipper_info>" & encodeXMLCode(GetBusinessInfo(dataTable("consignee_acct")) & chr(13) & GetBusinessTelFax(dataTable("shipper_acct"))) & "</shipper_info>")
            Response.Write("<customer_name>" & encodeXMLCode(GetBusinessName(dataTable("customer_acct"))) & "</customer_name>")
            Response.Write("<customer_info>" & encodeXMLCode(GetBusinessInfo(dataTable("customer_acct"))& chr(13) & GetBusinessTelFax(dataTable("customer_acct"))) & "</customer_info>")
            Response.Write("<trucker_name>" & encodeXMLCode(GetBusinessName(dataTable("trucker_acct"))) & "</trucker_name>")
            Response.Write("<trucker_info>" & encodeXMLCode(GetBusinessTelFax(dataTable("trucker_acct"))) & "</trucker_info>")
        End If
        Response.Write "</FormDocument>"
        
    End Sub

    Sub get_search_list()
        Dim SQL,rs
        
        SQL = "SELECT DISTINCT " & topNum & " auto_uid,so_num FROM warehouse_shipout WHERE elt_account_number=" _
            & elt_account_number & " AND so_num like N'" & qStr & "%' "
        If cursorStr <> "" Then
            SQL = SQL & " AND auto_uid>(select auto_uid from warehouse_shipout b where b.elt_account_number=elt_account_number and CAST(so_num  as NVARCHAR)=N'" & cursorStr & "') "
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
            Response.Write "<label>" & rs("so_num").value & "</label>"
            Response.Write "</item>"
            rs.MoveNext
	    Loop
        Response.Write "</FormDocument>"
        rs.Close()
    End Sub
       
    Sub get_search_list2()
        Dim SQL,rs
        
        SQL = "SELECT DISTINCT " & topNum & " auto_uid,so_num FROM warehouse_shipout where  elt_account_number="_
            & elt_account_number & " AND so_num like N'" & qStr & "%' "
        If cursorStr <> "" Then
            SQL = SQL & " AND auto_uid>(select auto_uid from warehouse_shipout b where b.elt_account_number=elt_account_number and CAST(so_num  as NVARCHAR)=N'" & cursorStr & "') "
        End If 
        SQL = SQL & " AND CAST(so_num as NVARCHAR)>=N'" & cursorStr & "' and so_num = any(select so_num from warehouse_history "_
            & "where elt_account_number= "& elt_account_number & "and history_type = 'Ship-out Made') order by auto_uid"

        
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
            Response.Write "<label>" & rs("so_num").value & "</label>"
            Response.Write "</item>"
            rs.MoveNext
	    Loop
        Response.Write "</FormDocument>"
        rs.Close()
    End Sub
    
    Sub delete_from_table()
        Dim SQL,rs,deleteRs
        SQL = "SELECT * FROM warehouse_shipout WHERE auto_uid=" & uid
        
        
        Set rs = Server.CreateObject("ADODB.Recordset")
	    rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing
        
        If NOT rs.EOF AND NOT rs.BOF Then
            so_num = rs("so_num").value
            SQL = "DELETE FROM warehouse_shipout WHERE auto_uid=" & uid & " AND " _
                & "elt_account_number=" & elt_account_number
            
            
            Set deleteRs = Server.CreateObject("ADODB.Recordset")
            Set deleteRs = eltConn.execute(SQL)
            Response.Write("The Shipout Number" & so_num & " has been deleted successfully")
            Call delete_from_history_table(so_num)
        End If
        rs.close()


    End Sub 
   
    
    Sub record_WR_history(warehouseID,history_type,item_remain,item_origin)
        Dim SQL,rs
        
        SQL = "INSERT INTO warehouse_history(so_num,wr_num,elt_account_number,history_type," _
            & "item_piece_shipout) VALUES(N'" & warehouseID & "'," _
            & elt_account_number & ",'" & history_type & "'," & item_remain & "," & item_origin & ")"
        
        
        Set rs = Server.CreateObject("ADODB.Recordset")
        Set rs = eltConn.execute(SQL)
    End Sub
    
    Sub delete_from_history_table(sonum)
        
        Dim SQL,rs,updateRS,PIC,wrNum
        SQL = "SELECT * FROM warehouse_history WHERE so_num=N'" & sonum &"'"
        
        
        Set rs = Server.CreateObject("ADODB.Recordset")
	    rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing
        
        If NOT rs.EOF AND NOT rs.BOF Then
            Do While Not rs.EOF 
                wrnum = rs("wr_num").value
                PIC = rs("item_piece_shipout").value

                SQL = "BEGIN TRANSACTION " _
                    & "UPDATE warehouse_history SET item_piece_remain = (item_piece_remain+" _
                    & PIC & ") WHERE wr_num=N'" & wrnum & "'AND so_num>N'" _
                    & sonum & "' AND elt_account_number=" & elt_account_number _
                    & "UPDATE warehouse_receipt SET item_piece_remain = (item_piece_remain+" _
                    & PIC & ")WHERE wr_num=N'" & wrnum & "' AND elt_account_number=" & elt_account_number _
                    & "UPDATE warehouse_history SET history_type='Shipout Deleted' WHERE so_num=N'" & sonum & "'" _
                    & "COMMIT"
                
                    
                Set updateRS = Server.CreateObject("ADODB.RecordSet")
                Set updateRS = eltConn.execute(SQL)

	            rs.MoveNext
	            
            Loop
            rs.close()

        End If
    End Sub

%>