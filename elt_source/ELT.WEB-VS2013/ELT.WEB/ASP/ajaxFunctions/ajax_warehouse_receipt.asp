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
    Dim session_server_name,session_user_lname,redPage,error_code 
    '// error_code 1,2
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
	
	Dim mode,qStr,topNum,cursorStr,uid,wr_num
	
    mode = checkBlank(Request.QueryString("mode"),"")
    uid = checkBlank(Request.QueryString("uid"),-1)
    qStr = checkBlank(Request.QueryString("qStr"),"")
    topNum = checkBlank("TOP " & Request.QueryString("limit"),"")
    cursorStr = checkBlank(Request.QueryString("cursor"),"")
    error_code = -1
    
    If mode = "view" Then
        Call get_all_info()
    Elseif mode = "list" or mode = "list2" Then
        Call get_search_list()
    Elseif mode = "update" Then
        eltConn.BeginTrans
        On Error Resume Next:
        Call save_to_table()
        If eltConn.Errors.Count > 0 Then
            error_code = -2
            eltConn.RollbackTrans
        Else
            eltConn.CommitTrans
        End If
        Call save_response()
    Elseif mode = "delete" And uid <> "" Then
        eltConn.BeginTrans
        On Error Resume Next:
        Call delete_from_table()
        If eltConn.Errors.Count > 0 Then
            error_code = -2
            eltConn.RollbackTrans
            Response.Write("Unexpected error has occurred while deleting. Please, contact us for further instruction.")
        Else
            Response.Write("The warehouse receipt " & wr_num & " has been deleted successfully")
            eltConn.CommitTrans
        End If
    Elseif mode = "shipCheck" And qStr <> "" Then
        Call check_if_shipped()
    End If
    
    eltConn.Close()
    Set eltConn = Nothing
    
    '/////////////////////////////////////////////////////////////////////////////////
    
    Sub save_response()
        Response.Expires = 0  
        Response.AddHeader "Pragma","no-cache"  
        Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
        Response.ContentType = "text/xml"
        Response.CharSet = "utf-8"
        Response.Write "<?xml version=""1.0"" encoding=""utf-8""?>"
        Response.Write "<savedItem>"
            Response.Write("<wr_num>" & wr_num & "</wr_num>")
            Response.Write("<uid>" & uid & "</uid>")
            Response.Write("<error_code>" & error_code & "</error_code>")
        Response.Write "</savedItem>"
    End Sub
    
    Sub get_all_info()
        Dim SQL,dataTable,dataObj
        
        SQL = "SELECT TOP 1 * FROM warehouse_receipt WHERE elt_account_number=" & elt_account_number _
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
            Response.Write("<shipper_name>" & encodeXMLCode(GetBusinessName(dataTable("shipper_acct"))) & "</shipper_name>")
            Response.Write("<shipper_info>" & encodeXMLCode(GetBusinessInfo(dataTable("shipper_acct")) & chr(13) & GetBusinessTelFax(dataTable("shipper_acct"))) & "</shipper_info>")
            Response.Write("<customer_name>" & encodeXMLCode(GetBusinessName(dataTable("customer_acct"))) & "</customer_name>")
            Response.Write("<customer_info>" & encodeXMLCode(GetBusinessInfo(dataTable("customer_acct"))& chr(13) & GetBusinessTelFax(dataTable("customer_acct"))) & "</customer_info>")
            Response.Write("<trucker_name>" & encodeXMLCode(GetBusinessName(dataTable("trucker_acct"))) & "</trucker_name>")
            Response.Write("<trucker_info>" & encodeXMLCode(GetBusinessTelFax(dataTable("trucker_acct"))) & "</trucker_info>")
        End If
        Response.Write "</FormDocument>"
    End Sub
    
    Sub get_search_list()
        Dim SQL,rs
        
        SQL = "SELECT DISTINCT " & topNum & " auto_uid,wr_num FROM warehouse_receipt WHERE elt_account_number=" _
            & elt_account_number & " AND wr_num like N'" & qStr & "%' "
        
        If cursorStr <> "" Then
            SQL = SQL & " AND auto_uid>(select auto_uid from warehouse_receipt b where b.elt_account_number=elt_account_number and CAST(wr_num  as NVARCHAR)=N'" & cursorStr & "') "
        End If   
        
        if mode = "list2" then
			SQL = SQL & " and item_piece_remain>0"
        end if
        
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
            Response.Write "<label>" & rs("wr_num").value & "</label>"
            Response.Write "</item>"
            rs.MoveNext
	    Loop
        Response.Write "</FormDocument>"
        rs.Close()
    End Sub
    
    Sub save_to_table()
        Dim SQL,dataObj,dataTable,i,isNewNumber
        isNewNumber = False

        wr_num = Request.Form.Item("txtWRNum")
        If isnull(wr_num) Or Trim(wr_num) = "" Then
            wr_num = GetPrefixFileNumber("WR", elt_account_number,"")
            isNewNumber = True
            If IsDataExist("SELECT * FROM warehouse_receipt where elt_account_number=" & elt_account_number & " AND wr_num=N'" & wr_num & "'") Then
                error_code = 2
                Exit Sub
            Elseif wr_num = "" Then
                error_code = 1
                Exit Sub
            End IF
        End If

        Set dataObj = new DataManager
        Set dataTable = Server.CreateObject("System.Collections.HashTable")

        dataTAble.Add "elt_account_number",elt_account_number
        dataTAble.Add "wr_num", wr_num
        dataTAble.Add "carrier_ref_no", Request.Form("txtCarrierRefNo")
        dataTAble.Add "customer_ref_no", Request.Form("txtCustomerRefNo")

        dataTAble.Add "created_date", Request.Form("txtUpdatedDate")
        dataTAble.Add "received_date", Request.Form("txtReceivedDate")
        dataTAble.Add "pickup_date", Request.Form("txtPickupDate")
        dataTAble.Add "storage_date", Request.Form("txtStorageDate")
        
        dataTAble.Add "shipper_acct", Request.Form("hReceivedFromAcct")
        dataTAble.Add "customer_acct", Request.Form("hAccountOfAcct")
        dataTAble.Add "trucker_acct", Request.Form("hTruckerAcct")
        dataTAble.Add "shipper_contact", Request.Form("txtReceivedFromContact")
        dataTAble.Add "customer_contact", Request.Form("txtAccountOfContact")        
        
        dataTAble.Add "inland_amount", checkBlank(Request.Form("txtInlandCharge"),0)
        dataTAble.Add "inland_type", Request.Form("hInlandChargeType")
        dataTAble.Add "danger_good", Request.Form("hDangerGood")
        dataTAble.Add "handling_info", Request.Form("txtHandling")
        
        Dim items
        items = checkBlank(Request.Form("txtItemPieces"),0)
        
        SQL = "SELECT * FROM warehouse_history WHERE wr_num=N'" & wr_num _
            & "' AND history_type='Ship-out Made' AND elt_account_number=" & elt_account_number

        If Not IsDataExist(SQL) Then
            dataTAble.Add "item_piece_origin", items
            dataTAble.Add "item_piece_remain", items
        End If
        
        dataTAble.Add "item_desc", Request.Form("txtItemDesc")
        dataTAble.Add "item_weight", checkBlank(Request.Form("txtGrossWeight"),0)
        dataTAble.Add "item_weight_scale", Request.Form("lstWeightScale")
        dataTAble.Add "item_dimension", Request.Form("txtDimension")
        dataTAble.Add "item_dimension_scale", Request.Form("lstDimScale")
        dataTAble.Add "item_remark", Request.Form("txtDamageException")
        dataTAble.Add "PO_NO", Request.Form("txtPONO")
        SQL = "SELECT * FROM warehouse_receipt where elt_account_number=" _
            & elt_account_number & " AND auto_uid=" & uid
        
        Dim cursorFinder
        cursorFinder = "SELECT TOP 1 auto_uid FROM warehouse_receipt where elt_account_number=" _
            & elt_account_number & " order by auto_uid desc"
        dataObj.SetColumnKeys("warehouse_receipt")
        
        '// cursorFinder is to find updated row index
        uid = dataObj.Return1stUpdateDBRow(SQL, dataTable, cursorFinder)

        If FormatNumberPlus(uid,0) > 0 And isNewNumber Then 
        '// If successful
            Call SetNextPrefixFileNumber("WR", elt_account_number,"")
            Call record_WR_history(wr_Num,"Warehouse Created",items,items)
        Elseif FormatNumberPlus(uid,0) <= 0 Then
            error_code = 2
            Exit Sub
        Else
        End If
        
    End Sub
    
    Sub delete_from_table()
        Dim SQL,rs,deleteRs

        SQL = "SELECT * FROM warehouse_receipt WHERE auto_uid=" & uid
        
        Set rs = Server.CreateObject("ADODB.Recordset")
	    rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing
        
        If NOT rs.EOF AND NOT rs.BOF Then
            wr_num = rs("wr_num").value
            SQL = "DELETE FROM warehouse_receipt WHERE auto_uid=" & uid & " AND " _
                & "elt_account_number=" & elt_account_number
            
            Set deleteRs = Server.CreateObject("ADODB.Recordset")
            Set deleteRs = eltConn.execute(SQL)
            
            SQL = "DELETE FROM warehouse_history WHERE wr_num=N'" & wr_num & "' AND " _
                & "elt_account_number=" & elt_account_number & " AND history_type='Warehouse Created'"
            
            Set deleteRs = Server.CreateObject("ADODB.Recordset")
            Set deleteRs = eltConn.execute(SQL)
        End If
        rs.close()

    End Sub 
   
    
    Sub record_WR_history(warehouseID,history_type,item_remain,item_origin)
        Dim SQL,rs
        
        SQL = "INSERT INTO warehouse_history(wr_num,elt_account_number,history_type," _
            & "item_piece_remain,item_piece_origin) VALUES(N'" & warehouseID & "'," _
            & elt_account_number & ",N'" & history_type & "'," & item_remain & "," & item_origin & ")"
        
        Set rs = Server.CreateObject("ADODB.Recordset")
        Set rs = eltConn.execute(SQL)
    End Sub

    Sub check_if_shipped()
        Dim SQL,rs

        SQL = "SELECT * FROM warehouse_history WHERE wr_num=N'" & qStr _
            & "' AND history_type='Ship-out Made' AND elt_account_number=" & elt_account_number
        
        If IsDataExist(SQL) Then
            Response.Write("Lock")
        Else
            Response.Write("Unlock")
        End If
    End Sub
%>