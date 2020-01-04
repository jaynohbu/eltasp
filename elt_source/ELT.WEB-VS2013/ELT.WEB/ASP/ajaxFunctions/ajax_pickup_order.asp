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
        Call get_pickup_list()
    Elseif mode = "update" Then
        Call save_to_table()
        Call save_response()
    Elseif mode = "delete" And search_no <> "" And search_no > 0 Then
        Call delete_from_table()
        Response.Write("Pickup Order # '" & po_num & "' has been deleted successfully")
    Else
    End If
    
    eltConn.Close()
    Set eltConn = Nothing
    
    Sub save_response()
        Response.Expires = 0
        Response.AddHeader "Pragma","no-cache"
        Response.AddHeader "Cache-Control","no-cache,must-revalidate"
        Response.ContentType = "text/xml"
        Response.CharSet = "utf-8"
        Response.Write "<?xml version=""1.0"" encoding=""utf-8""?>"
        Response.Write "<savedItem>"
            Response.Write("<po_num>" & po_num & "</po_num>")
            Response.Write("<uid>" & search_no & "</uid>")
            Response.Write("<error_code>" & error_code & "</error_code>")
        Response.Write "</savedItem>"
    End Sub
    
    
    Sub delete_from_table()
        Dim SQL,rs,deleteRs

        SQL = "SELECT * FROM pickup_order WHERE auto_uid=" & search_no & " AND " _
            & "elt_account_number=" & elt_account_number
        Set rs = Server.CreateObject("ADODB.Recordset")
	    rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing
        
        If NOT rs.EOF AND NOT rs.BOF Then
            po_num = rs("po_num").value
            SQL = "DELETE FROM pickup_order WHERE auto_uid=" & search_no & " AND " _
                & "elt_account_number=" & elt_account_number
            Set deleteRs = Server.CreateObject("ADODB.Recordset")
            Set deleteRs = eltConn.execute(SQL)
        End If
        rs.close()
    End Sub 
    
    Sub save_to_table()
        Dim SQL,dataTable,i,isNewNumber
        
        isNewNumber = False
               
        Set dataObj = new DataManager
        Set dataTable = Server.CreateObject("System.Collections.HashTable")

        po_num = Request.Form.Item("txtPickupNumber")
        If isnull(po_num) Or Trim(po_num) = "" Then
            po_num = GetPrefixFileNumber("PUO", elt_account_number,"")

            If IsDataExist("SELECT * FROM pickup_order where elt_account_number=" & elt_account_number & " AND po_num=N'" & po_num & "'") Then
                error_code = 2
                Exit Sub
            Elseif po_num = "" Then
                '// Prefix not set create new
                error_code = 1
                '// Exit Sub
                po_num = GetSQLResult("SELECT 'none-' + cast(max(auto_uid)+1 as NVarchar) FROM pickup_order", Null)
            Else
                isNewNumber = True
            End IF
        Else
            If GetPrefixFileNumber("PUO", elt_account_number,"") = "" Then
                '// Prefix not set update
                error_code = 1
            End If
        End If

        dataTable.Add "po_num", po_num 
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
        dataTable.Add "elt_account_number", elt_account_number
        dataTable.Add "session_id", Session.SessionID
        dataTable.Add "is_hazard", Request.Form("hDangerGoods").Item 
        
        SQL = "SELECT * FROM pickup_order WHERE elt_account_number=" & elt_account_number _
            & " AND auto_uid=" & search_no

        Dim cursorFinder 
        cursorFinder = "SELECT TOP 1 auto_uid FROM pickup_order where elt_account_number=" & elt_account_number _
            & " order by auto_uid desc"   

        dataObj.SetColumnKeys("pickup_order")
        search_no = dataObj.Return1stUpdateDBRow(SQL, dataTable, cursorFinder)
        
        If FormatNumberPlus(search_no,0) > 0 And isNewNumber Then 
        '// If successful
            Call SetNextPrefixFileNumber("PUO", elt_account_number,"")
        Elseif FormatNumberPlus(search_no,0) <= 0 Then
            error_code = 3
            search_no = 0 
            Exit Sub
        Else
        '// If successful without prefix
        End If
        
    End Sub

    Sub get_all_info()
    
        Dim SQL,dataTable

        SQL = "SELECT TOP 1 * FROM pickup_order WHERE elt_account_number=" & elt_account_number _
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
        If dataObj.DataList.Count > 0 Then
            Response.Write(MakeXMLString(dataTable,dataObj.GetKeyArray()))
            Response.Write("<trucker_info>" & encodeXMLCode(GetBusinessTelFax(dataTable("trucker_acct"))) & "</trucker_info>")
        End If
        Response.Write "</FormDocument>"
        
    End Sub
    
    
    Sub get_pickup_list()
        Dim SQL,rs, vNextNum
        
        vNextNum = GetPrefixFileNumber("PUO", elt_account_number,"")
        
        If vNextNum = "" Then
            SQL = "SELECT DISTINCT " & topNum & " auto_uid,po_num, ModifiedDate FROM pickup_order WHERE elt_account_number=" _
                & elt_account_number & " AND auto_uid like N'" & qStr & "%'"
            If cursorStr <> "" Then
                SQL = SQL & " AND auto_uid>(select auto_uid from pickup_order b where b.elt_account_number=elt_account_number and CAST(auto_uid as NVARCHAR)=N'" & cursorStr & "') "
            End If   
        Else
            SQL = "SELECT DISTINCT " & topNum & " auto_uid,po_num, ModifiedDate FROM pickup_order WHERE elt_account_number=" _
                & elt_account_number & " AND po_num like N'" & qStr & "%'"
            If cursorStr <> "" Then
                SQL = SQL & " AND auto_uid>(select auto_uid from pickup_order b where b.elt_account_number=elt_account_number and CAST(po_num as NVARCHAR)=N'" & cursorStr & "') "
            End If    
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
            If vNextNum = "" Then
                Response.Write "<label>" & rs("auto_uid").value & "</label>"
            Else
                Response.Write "<label>" & checkBlank(rs("po_num").value, rs("auto_uid").value) & "</label>"
            End If
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
