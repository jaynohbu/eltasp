
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
	
    Dim search_type,search_no,ship_type,dataObj,mode,qStr,topNum,cursorStr
    
    search_type = checkBlank(Request.QueryString("type"),"")
    search_no = checkBlank(Request.QueryString("no"),-1)
    ship_type = checkBlank(Request.QueryString("export"),"")
    mode = checkBlank(Request.QueryString("mode"),"")
    qStr = checkBlank(Request.QueryString("qStr"),"")
    topNum = checkBlank("TOP " & Request.QueryString("limit"),"")
    cursorStr = checkBlank(Request.QueryString("cursor"),"")
    
    If mode = "view" Then
        Call get_all_info()
    Elseif mode = "list" Then
        Call get_pickup_list()
    Elseif mode = "update" Then
        Call save_to_table()
        If CInt(search_no) > 0 Then
            '// Response.Write("Pickup Order # '" & search_no & "' has been saved successfully")
            Response.Write(search_no)
        Else
            Response.Write("Failed to update/add this information.\nPlease check the form again.")
        End If
    Elseif mode = "delete" And search_no <> "" And search_no > 0 Then
        Call delete_from_table()
        Response.Write("Pickup Order # '" & search_no & "' has been deleted successfully")
        
    Else
    End If
    
    Sub delete_from_table()
        Dim SQL,rs
        
        SQL = "DELETE FROM pickup_order WHERE auto_uid=" & search_no & " AND " _
            & "elt_account_number=" & elt_account_number
        Set rs = Server.CreateObject("ADODB.Recordset")
        Set rs = eltConn.execute(SQL)

    End Sub
    
    Sub save_to_table()
        Dim SQL,dataTable,i
        Set dataObj = new DataManager
        Set dataTable = Server.CreateObject("System.Collections.HashTable")

        dataTAble.Add "pickup_ref_num", Request.Form("txtPickupRefNum").Item
        dataTable.Add "Shipper_account_number" , Request.Form("hShipperAcct").Item
        dataTable.Add "Shipper_Name" , Request.Form("lstShipperName").Item
        dataTable.Add "Shipper_Info" , Request.Form("txtShipperInfo").Item
        dataTable.Add "Pickup_account_number" , Request.Form("hPickupAcct").Item
        dataTable.Add "Pickup_Name" , Request.Form("lstPickupName").Item
        dataTable.Add "Pickup_Info" , Request.Form("txtPickupInfo").Item
        dataTable.Add "Carrier_account_number" , Request.Form("hCarrierAcct").Item
        dataTable.Add "Carrier_Name" , Request.Form("lstCarrierName").Item
        dataTable.Add "Carrier_Info" , Request.Form("txtCarrierInfo").Item
        dataTable.Add "Carrier_Code" , Request.Form("hCarrierCode").Item

        dataTable.Add "Booking_NUM" , Request.Form("txtBooking").Item
        dataTable.Add "MAWB_NUM" , Request.Form("txtMAWB").Item
        dataTable.Add "HAWB_NUM" , Request.Form("txtHAWB").Item
        
        dataTable.Add "contact" , Request.Form("txtContact").Item
        dataTable.Add "ModifiedDate" , Date()
        
        dataTable.Add "cargo_location" , Request.Form("txtCargoLocation").Item
        dataTable.Add "sub_hawb_no" , Request.Form("txtSubHAWB").Item
        dataTable.Add "entry_billing_no" , Request.Form("txtEntryBilling").Item
        dataTable.Add "customer_ref_no" , Request.Form("txtCustomerRef").Item
        dataTable.Add "ETA_DATE1" , Request.Form("txtArrDate").Item
        dataTable.Add "ETD_DATE1" , Request.Form("txtDepDate").Item
        dataTable.Add "free_date" , Request.Form("txtFreeDate").Item
        
        dataTable.Add "Origin_Port_Location" , Request.Form("lstDepPort").Item
        dataTable.Add "Origin_Port_Code" , Request.Form("hDepPortCode").Item
        dataTable.Add "Dest_Port_Location" , Request.Form("lstArrPort").Item
        dataTable.Add "Dest_Port_Code" , Request.Form("hArrPortCode").Item
        
        dataTable.Add "trucker_name" , Request.Form("lstTruckerName").Item
        dataTable.Add "trucker_acct" , Request.Form("hTruckerAcct").Item
        dataTable.Add "trucker_info" , Request.Form("txtTruckerInfo").Item
        
        dataTable.Add "attention" , Request.Form("txtAttention").Item
        dataTable.Add "route" , Request.Form("txtRoute").Item
        dataTable.Add "Handling_Info" , Request.Form("txtHandling").Item
        dataTable.Add "Total_Pieces" , Request.Form("txtPieces").Item
        dataTable.Add "Desc2" , Request.Form("txtDesc3").Item
        dataTable.Add "Weight_Scale" , Request.Form("lstScale1").Item
        dataTable.Add "Total_Gross_Weight" , Request.Form("txtGrossWt").Item
        
        dataTable.Add "dimension" , Request.Form("txtDimension").Item
        
        dataTable.Add "inland_charge" , Request.Form("txtInlandCharge").Item
        dataTable.Add "inland_charge_type" , Request.Form("hInlandChargeType").Item 
        dataTable.Add "employee" , Request.Form("txtEmployee").Item
        '// dataTable.Add "eType", ship_type
        dataTable.Add "elt_account_number", elt_account_number
        dataTable.Add "session_id", Session.SessionID
        
        SQL = "SELECT * FROM pickup_order WHERE elt_account_number=" & elt_account_number _
            & " AND auto_uid=" & search_no
            
        
        Dim cursorFinder 
        cursorFinder = "SELECT TOP 1 auto_uid FROM pickup_order where elt_account_number=" & elt_account_number _
            & " order by auto_uid desc"   

        dataObj.SetColumnKeys("pickup_order")
        search_no = dataObj.Return1stUpdateDBRow(SQL, dataTable, cursorFinder)
    End Sub

    Sub get_all_info()
    
        Dim SQL,dataTable

        SQL = "SELECT TOP 1 * FROM pickup_order WHERE elt_account_number=" & elt_account_number _
			    & " AND auto_uid='" & search_no & "' ORDER BY auto_uid DESC"

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
        If dataObj.DataList.Count > 0 Then
            Response.Write(MakeXMLString(dataTable,dataObj.GetKeyArray()))
        End If
        Response.Write "</FormDocument>"
        
    End Sub
    
    
    Sub get_pickup_list()
        Dim SQL,rs
        
        SQL = "SELECT DISTINCT " & topNum & " auto_uid, ModifiedDate FROM pickup_order WHERE elt_account_number=" _
            & elt_account_number & " AND auto_uid like '" & qStr & "%' AND CAST(auto_uid as VARCHAR)>='" & cursorStr & "' order by auto_uid"

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
            '// Response.Write "<label>" & rs("ModifiedDate").value & " - " & rs("auto_uid").value & "</label>"
            Response.Write "<label>" & rs("auto_uid").value & "</label>"
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
