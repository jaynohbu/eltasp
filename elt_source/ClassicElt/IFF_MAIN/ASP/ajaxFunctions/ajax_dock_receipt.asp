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
	
	Dim mode,dock_no,qStr,topNum,cursorStr,uid
	
    mode = checkBlank(Request.QueryString("mode"),"")
    dock_no = checkBlank(Request.QueryString("dock"),"")
    uid = checkBlank(Request.QueryString("uid"),-1)
    qStr = checkBlank(Request.QueryString("qStr"),"")
    topNum = checkBlank("TOP " & Request.QueryString("limit"),"")
    cursorStr = checkBlank(Request.QueryString("cursor"),"")
    
    If mode = "view" Then
        Call get_all_info()
    Elseif mode = "list" Then
        Call get_search_list()
    Elseif mode = "update" Then
        save_to_table()
        If dock_no <> "" Then
            Response.Write("Dock Receipt #'" & dock_no & "' has been saved successfully")
        Else
            Response.Write("Dock Receipt #'" & dock_no & "' has failed")
        End If
    Elseif mode = "delete" And uid <> "" Then
        Call delete_from_table()
        Response.Write("Dock Receipt #'" & dock_no & "' has been deleted successfully")
    End If

    Response.End()
    
    '/////////////////////////////////////////////////////////////////////////////////
    
    Sub get_all_info()
        Dim SQL,dataTable,dataObj
        
        SQL = "SELECT TOP 1 * FROM warehouse_dock_receipt WHERE elt_account_number=" & elt_account_number _
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
        End If
        Response.Write "</FormDocument>"
    End Sub
    
    Sub get_search_list()
        Dim SQL,rs
        
        SQL = "SELECT DISTINCT " & topNum & " auto_uid,dock_no FROM warehouse_dock_receipt WHERE elt_account_number=" _
            & elt_account_number & " AND dock_no like N'" & qStr & "%' " _
            & "AND CAST(dock_no as NVARCHAR)>=N'" & cursorStr & "' order by dock_no"

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
            Response.Write "<label>" & rs("dock_no").value & "</label>"
            Response.Write "</item>"
            rs.MoveNext
	    Loop
        Response.Write "</FormDocument>"
        rs.Close()
    End Sub
    
    Sub save_to_table()
        Dim SQL,dataObj,dataTable,i
        
        dock_no = checkBlank(Request.Form("txtDRNum"),GetPrefixFileNumber("DOCK", elt_account_number,""))
        
        If dock_no = "" Then 
            Exit Sub
        End If
        
        Set dataObj = new DataManager
        Set dataTable = Server.CreateObject("System.Collections.HashTable")

        dataTAble.Add "elt_account_number",elt_account_number
        dataTAble.Add "dock_no", dock_no
        dataTAble.Add "master_no", Request.Form("txtMAWBNum")
        dataTAble.Add "house_no", Request.Form("txtHAWBNum")
        dataTAble.Add "booking_no", Request.Form("txtBookingNum")
        dataTAble.Add "executed_date", Request.Form("txtUpdatedDate")
        dataTAble.Add "export_references", Request.Form("txtExportRef")
        dataTAble.Add "shipper_acct", Request.Form("hShipperAcct")
        dataTAble.Add "shipper_name", Request.Form("lstShipperName")
        dataTAble.Add "shipper_info", Request.Form("txtShipperInfo")
        dataTAble.Add "consignee_acct", Request.Form("hConsigneeAcct")
        dataTAble.Add "consignee_name", Request.Form("lstConsigneeName")
        dataTAble.Add "consignee_info", Request.Form("txtConsigneeInfo")
        dataTAble.Add "agent_acct", Request.Form("hAgentAcct")
        dataTAble.Add "agent_name", Request.Form("lstAgentName")
        dataTAble.Add "agent_info", Request.Form("txtAgentInfo")
        dataTAble.Add "notify_acct", Request.Form("hNotifyAcct")
        dataTAble.Add "notify_name", Request.Form("lstNotifyName")
        dataTAble.Add "notify_info", Request.Form("txtNotifyInfo")
        dataTAble.Add "trucker_acct", Request.Form("hTruckerAcct")
        dataTAble.Add "trucker_name", Request.Form("lstTruckerName")
        dataTAble.Add "trucker_info", Request.Form("txtTruckerInfo")
        dataTAble.Add "origin_point", Request.Form("txtUsState")
        dataTAble.Add "routing_instructions", Request.Form("txtExportInstr")
        dataTAble.Add "pre_carrier", Request.Form("txtPreCarriage")
        dataTAble.Add "pre_carrier_place", Request.Form("txtPreReceiptPlace")
        dataTAble.Add "export_carrier", Request.Form("txtExportCarrier")
        dataTAble.Add "load_port", Request.Form("txtLoadingPort")
        dataTAble.Add "load_port_terminal", Request.Form("txtLoadingTerminal")
        dataTAble.Add "unload_port", Request.Form("txtUnloadingPort")
        dataTAble.Add "delivery_place", Request.Form("txtDeliveryPlace")
        dataTAble.Add "move_type", Request.Form("txtMoveType")
        dataTAble.Add "containerized", Request.Form("hContainerized")
        dataTAble.Add "item_marks", Request.Form("txtDesc1")
        dataTAble.Add "item_pieces", Request.Form("txtDesc2")
        dataTAble.Add "item_desc", Request.Form("txtDesc3")
        dataTAble.Add "item_weight", Request.Form("txtGrossWeight")
        dataTAble.Add "item_weight_scale", Request.Form("lstWeightScale")
        dataTAble.Add "item_measurement", Request.Form("txtMeasurement")
        dataTAble.Add "prepared_by", Request.Form("txtPrepareBy")

        
        SQL = "SELECT * FROM warehouse_dock_receipt where elt_account_number=" _
            & elt_account_number & " AND auto_uid=" & uid
        
        Dim cursorFinder 
        cursorFinder = "SELECT TOP 1 auto_uid FROM warehouse_dock_receipt where elt_account_number=" _
            & elt_account_number & " order by auto_uid desc"   
        dataObj.SetColumnKeys("warehouse_dock_receipt")
        
        '// cursorFinder is to find updated row index
        uid = dataObj.Return1stUpdateDBRow(SQL, dataTable, cursorFinder)
        dock_no = Request.Form("txtDRNum")

    End Sub

    Sub delete_from_table()
        Dim SQL,rs
        
        SQL = "DELETE FROM warehouse_dock_receipt WHERE auto_uid=" & uid & " AND " _
            & "elt_account_number=" & elt_account_number
        Set rs = Server.CreateObject("ADODB.Recordset")
        Set rs = eltConn.execute(SQL)
    End Sub
    
%>