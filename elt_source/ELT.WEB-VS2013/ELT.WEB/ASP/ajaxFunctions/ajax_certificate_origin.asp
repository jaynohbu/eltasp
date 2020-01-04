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
	
    Dim search_type,search_no,ship_type,dataObj,mode,search_list,qStr,topNum,cursorStr
    
    search_type = checkBlank(Request.QueryString("type"),"")
    search_no = checkBlank(Request.QueryString("no"),"")
    ship_type = checkBlank(Request.QueryString("export"),"")
    mode = checkBlank(Request.QueryString("mode"),"")
    qStr = checkBlank(Request.QueryString("qStr"),"")
    topNum = checkBlank("TOP " & Request.QueryString("limit"),"")
    if topNum ="TOP" then
    topNum ="TOP 100"
    end if 
    cursorStr = checkBlank(Request.QueryString("cursor"),"")
    
    eltConn.BeginTrans
    
    If search_no = "" And search_type = "" And ship_type = "" And mode <> "list" Then
		If mode = "view" Then
			Call get_empty_info()
		Else
			Response.Write("Please, validate the form first.")
		End If
		mode = ""
	End If
	
	If mode = "view" Then
	    If ship_type = "A" Then
            Call get_all_air_info()
        Elseif ship_type = "O" Then
            Call get_all_ocean_info()
        Else
        End If
    Elseif mode = "update" Then
        If search_type <> "" And search_type <> "none" And search_no <> "" And search_no <> "Select One" And ship_type <> "" And Request.Form.Count > 0 Then
            Call save_to_table()
            If search_type = "house" Then
                Response.Write("House bill '" & search_no & "' has been updated successfully")
            Elseif search_type = "master" Then
                Response.Write("Master bill/Booking No. '" & search_no & "' has been updated successfully")
            Else
                Response.Write("Unknown operation")
            End If
        Elseif search_type = "none" And Request.Form("txtFileName").Item <> "" And Request.Form("txtFileName").Item <> "Type file name"Then
            Call save_to_table()
            Response.Write("Anonymous file '" & Request.Form("txtFileName").Item & "' has been updated successfully")
        Else
            Response.Write("Please, validate the form before saving.")
        End If
    Elseif mode = "delete" Then
        If delete_from_table() Then
            Response.Write("Anonymous file '" & search_no & "' has been deleted successfully")
        Else
            Response.Write("Failed to delete Anonymous file '" & search_no & "'")
        End If
    Elseif mode = "list" Then
    
        If search_type = "house" Then
            Set search_list = get_export_HAWB_list()
        Elseif search_type = "master" Then
            Set search_list = get_export_MAWB_list()
        Elseif search_type = "booking" Then
            Set search_list = get_export_booking_list()
        Elseif search_type = "none" Then
            Set search_list = get_none_array()
        Else
        End If
        Call write_import_xml()
    Else
	End If

    eltConn.CommitTrans
    eltConn.Close()
    Set eltConn = Nothing
    
    Function delete_from_table()
        Dim SQL,resVal
        Dim deleteID,rs,delRs,table_name

        resVal = False
        
        Set rs = Server.CreateObject("ADODB.Recordset")
        Set delRs = Server.CreateObject("ADODB.Recordset")
        
        If checkBlank(search_no,"") <> "" Then
 
            If ship_type = "A" Then
                SQL = "SELECT auto_uid from certificate_origin_air where elt_account_number=" _
                    & elt_account_number & " AND file_name=N'" & search_no &"' AND anonymous='Y'"
                
                Set rs = eltConn.execute(SQL)
                Do While Not rs.eof And Not rs.bof 
                    deleteID = rs("auto_uid").value
                    SQL = "DELETE FROM certificate_origin_air_items where cert_id=" & deleteID
                    
                    Set delRs = eltConn.execute(SQL)
                    rs.MoveNext
                Loop
                SQL = "DELETE FROM certificate_origin_air where elt_account_number=" & elt_account_number _
                    & " AND file_name=N'" & search_no &"' AND anonymous='Y'"
                
                Set rs = eltConn.execute(SQL)
            Else
                SQL = "SELECT auto_uid from certificate_origin_ocean where elt_account_number=" _
                    & elt_account_number & " AND file_name=N'" & search_no &"' AND anonymous='Y'"
                
                Set rs = eltConn.execute(SQL)
                Do While Not rs.eof And Not rs.bof 
                    deleteID = rs("auto_uid").value
                    SQL = "DELETE FROM certificate_origin_ocean_items where cert_id=" & deleteID
                    
                    Set delRs = eltConn.execute(SQL)
                    rs.MoveNext
                Loop
                SQL = "DELETE FROM certificate_origin_ocean where elt_account_number=" & elt_account_number _
                    & " AND file_name=N'" & search_no &"' AND anonymous='Y'"
                
                Set rs = eltConn.execute(SQL)
            End If
            If eltConn.Errors.Count = 0 then
                resVal = True
            End If
        End If
        delete_from_table = resVal
    End Function

    Sub get_all_ocean_info()
    
        Dim SQL,dataTable
    
        If search_type = "master" Then
            SQL = "SELECT TOP 1 * FROM certificate_origin_ocean a LEFT JOIN certificate_origin_ocean_items b "_
                & "ON a.auto_uid = b.cert_id WHERE a.elt_account_number=" & elt_account_number _
                & " AND a.booking_num=N'" & search_no & "' ORDER BY auto_uid DESC"
            If IsEmptyRS(SQL) Then
                SQL = "SELECT booking_num,'' as hbol_num,mbol_num,elt_account_number,Shipper_Name as shipper_name,Shipper_Info as shipper_info,Shipper_acct_num as shipper_acct_num,Consignee_Name as consignee_name,Consignee_Info as consignee_info,Consignee_acct_num as consignee_acct_num,agent_name,agent_info,agent_acct_num,Notify_Name as notify_name,Notify_Info as notify_info,Notify_acct_num as notify_acct_num,export_ref,origin_country as us_state,origin_country as origin_state,export_instr,pre_carriage,pre_receipt_place,export_carrier,loading_port,loading_pier,unloading_port,delivery_place,move_type,containerized,desc1,pieces as desc2,desc3,gross_weight,measurement,'KG' as weight_scale,'CBM' as measurement_scale,ModifiedDate as updated_date,is_org_merged FROM mbol_master" _
                    & " WHERE elt_account_number=" & elt_account_number & " AND booking_num=N'" & search_no & "'"
            End If

        Elseif search_type = "house" Then
            SQL = "SELECT TOP 1 * FROM certificate_origin_ocean a LEFT JOIN certificate_origin_ocean_items b "_
                & "ON a.auto_uid = b.cert_id WHERE a.elt_account_number=" & elt_account_number _
                & " AND a.hbol_num=N'" & search_no & "' ORDER BY auto_uid DESC"
            If IsEmptyRS(SQL) Then
                SQL = "SELECT booking_num,hbol_num,mbol_num,elt_account_number,Shipper_Name as shipper_name,Shipper_Info as shipper_info,Shipper_acct_num as shipper_acct_num,Consignee_Name as consignee_name,Consignee_Info as consignee_info,Consignee_acct_num as consignee_acct_num,agent_name,agent_info,agent_no as agent_acct_num,Notify_Name as notify_name,Notify_Info as notify_info,Notify_acct_num as notify_acct_num,export_ref,origin_country as us_state,origin_country as origin_state,export_instr,pre_carriage,pre_receipt_place,export_carrier,loading_port,loading_pier,unloading_port,delivery_place,move_type,containerized,desc1,pieces as desc2,desc3,gross_weight,measurement,'KG' as weight_scale,'CBM' as measurement_scale,ModifiedDate as updated_date,is_org_merged FROM hbol_master" _
                    & " WHERE elt_account_number=" & elt_account_number & " AND hbol_num=N'" & search_no & "'"
            End If
            
        Elseif search_type = "none" Then
            SQL = "SELECT TOP 1 * FROM certificate_origin_ocean a LEFT JOIN certificate_origin_ocean_items b "_
                & "ON a.auto_uid = b.cert_id WHERE a.elt_account_number=" & elt_account_number _
                & " AND a.anonymous='Y' AND a.file_name=N'" & search_no & "' ORDER BY auto_uid DESC"
	    Else
        End If

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
        Response.Write "<Search_Mode>" & encodeXMLCode(search_type) & "</Search_Mode>"
        Response.Write "<Search_Num>" & encodeXMLCode(search_no) & "</Search_Num>"
        If dataObj.DataList.Count > 0 Then
            Response.Write(MakeXMLString(dataTable,dataObj.GetKeyArray()))
        End If
        Response.Write "</FormDocument>"
    
    End Sub
    
    Sub get_all_air_info()
        Dim SQL,dataTable
    
        If search_type = "master" Then
            SQL = "SELECT TOP 1 * FROM certificate_origin_air a LEFT JOIN certificate_origin_air_items b "_
                & "ON a.auto_uid = b.cert_id WHERE a.elt_account_number=" & elt_account_number _
                & " AND a.mawb_num=N'" & search_no & "' ORDER BY a.auto_uid DESC"
            If IsEmptyRS(SQL) Then
                SQL = "SELECT TOP 1 b.file# as doc_num,a.MAWB_NUM as mawb_num,a.elt_account_number,a.Shipper_Name as shipper_name,a.Shipper_Info as shipper_info,a.Shipper_account_number as shipper_acct_num,Consignee_Name as consignee_name,a.Consignee_Info as consignee_info,a.Consignee_acct_num as consignee_acct_num,a.Issue_Carrier_agent as agent_info,a.master_agent as agent_acct_num,a.Notify_no as notify_acct_num,d.dba_name as notify_name,a.Account_Info as notify_info,b.scac as us_state,b.Origin_Port_Country as origin_country,b.Carrier_Desc as export_carrier,b.Origin_Port_Location as loading_port,b.Dest_Port_Country as delivery_place,b.Dest_Port_Location as unloading_port,c.No_Pieces as desc2,c.Gross_Weight as gross_weight,c.Kg_Lb as weight_scale,0 as measurement " _
                    & " FROM MAWB_MASTER a LEFT OUTER JOIN MAWB_NUMBER b ON (a.elt_account_number=b.elt_account_number AND a.MAWB_NUM = b.mawb_no) LEFT OUTER JOIN mawb_weight_charge c ON (a.elt_account_number=c.elt_account_number AND a.MAWB_NUM = c.MAWB_NUM) LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND ISNULL(a.Notify_no,0) =  CAST(d.org_account_number AS NVARCHAR(64)))" _
                    & " WHERE a.elt_account_number=" & elt_account_number & " AND a.MAWB_NUM=N'" & search_no & "'"
            End If

        Elseif search_type = "house" Then
            SQL = "SELECT TOP 1 * FROM certificate_origin_air a LEFT JOIN certificate_origin_air_items b "_
                & "ON a.auto_uid = b.cert_id WHERE a.elt_account_number=" & elt_account_number _
                & " AND a.hawb_num=N'" & search_no & "' ORDER BY auto_uid DESC"
            If IsEmptyRS(SQL) Then
                SQL = "SELECT TOP 1 b.file# as doc_num,a.HAWB_NUM as hawb_num,a.MAWB_NUM as mawb_num,a.elt_account_number,a.Shipper_Name as shipper_name,a.Shipper_Info as shipper_info,a.Shipper_account_number as shipper_acct_num,Consignee_Name as consignee_name,a.Consignee_Info as consignee_info,a.Consignee_acct_num as consignee_acct_num,a.Agent_Name as agent_name,a.Agent_Info as agent_info,a.Agent_No as agent_acct_num,a.Notify_no as notify_acct_num,d.dba_name as notify_name,a.Account_Info as notify_info,b.scac as us_state,b.Origin_Port_Country as origin_country ,b.Carrier_Desc as export_carrier,b.Origin_Port_Location as loading_port,b.Dest_Port_Country as delivery_place,b.Dest_Port_Location as unloading_port,c.No_Pieces as desc2,a.manifest_desc as desc3,c.Gross_Weight as gross_weight,c.Kg_Lb as weight_scale,c.Dimension as measurement " _
                    & " FROM HAWB_MASTER a LEFT OUTER JOIN MAWB_NUMBER b ON (a.elt_account_number=b.elt_account_number AND a.MAWB_NUM = b.mawb_no) LEFT OUTER JOIN hawb_weight_charge c ON (a.elt_account_number=c.elt_account_number AND a.HAWB_NUM = c.HAWB_NUM) LEFT OUTER JOIN organization d ON (a.elt_account_number=d.elt_account_number AND ISNULL(a.Notify_no,0) =  CAST(d.org_account_number AS NVARCHAR(64)))" _
                    & " WHERE a.elt_account_number=" & elt_account_number & " AND a.HAWB_NUM=N'" & search_no & "'"
            End If
            
        Elseif search_type = "none" Then
            SQL = "SELECT TOP 1 * FROM certificate_origin_air a LEFT JOIN certificate_origin_air_items b "_
                & "ON a.auto_uid = b.cert_id WHERE a.elt_account_number=" & elt_account_number _
                & " AND a.anonymous='Y' AND a.file_name=N'" & search_no & "' ORDER BY auto_uid DESC"
	    Else
        End If

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
        Response.Write "<Search_Mode>" & encodeXMLCode(search_type) & "</Search_Mode>"
        Response.Write "<Search_Num>" & encodeXMLCode(search_no) & "</Search_Num>"
        If dataObj.DataList.Count > 0 Then
            Response.Write(MakeXMLString(dataTable,dataObj.GetKeyArray()))
        End If
        Response.Write "</FormDocument>"
    End Sub
    
    Sub get_empty_info(table_name)
		Dim SQL,dataTable
		Set dataObj = new DataManager
		SQL = "SELECT TOP 0 * FROM " & table_name
        dataObj.SetDataList(SQL)
        Set dataTable = dataObj.GetRowTable(0)

        Response.Expires = 0  
        Response.AddHeader "Pragma","no-cache"  
        Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
        Response.ContentType = "text/xml"
        Response.CharSet = "utf-8"
        Response.Write "<?xml version=""1.0"" encoding=""utf-8""?>"
        Response.Write "<FormDocument>"
        Response.Write "<Search_Mode>" & encodeXMLCode(search_type) & "</Search_Mode>"
        If dataObj.DataList.Count > 0 Then
            Response.Write(MakeXMLString(dataTable,dataObj.GetKeyArray()))
        End If
        Response.Write "</FormDocument>"

	End Sub 
    
    Sub save_to_table()
        Dim SQL,dataTable,i
        Dim cert_id 
        Set dataObj = new DataManager
        Set dataTable = Server.CreateObject("System.Collections.HashTable")

        dataTable.Add "booking_num", Request.Form("txtBookingNum").Item
        dataTable.Add "hbol_num", Request.Form("txtHBOLNum").Item
        dataTable.Add "mbol_num", Request.Form("txtMBOLNum").Item
        
        dataTable.Add "doc_num", Request.Form("txtDocNum").Item
        dataTable.Add "hawb_num", Request.Form("txtHawbNum").Item
        dataTable.Add "mawb_num", Request.Form("txtMawbNum").Item
        
        dataTable.Add "shipper_acct_num" , Request.Form("hShipperAcct").Item
        dataTable.Add "shipper_name", Request.Form("lstShipperName").Item
        dataTable.Add "shipper_info", Request.Form("txtShipperInfo").Item
        dataTable.Add "consignee_acct_num", Request.Form("hConsigneeAcct").Item
        dataTable.Add "consignee_name", Request.Form("lstConsigneeName").Item
        dataTable.Add "consignee_info", Request.Form("txtConsigneeInfo").Item
        dataTable.Add "agent_acct_num", Request.Form("hAgentAcct").Item
        dataTable.Add "agent_name", Request.Form("lstAgentName").Item
        dataTable.Add "agent_info", Request.Form("txtAgentInfo").Item
        dataTable.Add "notify_acct_num", Request.Form("hNotifyAcct").Item
        dataTable.Add "notify_name", Request.Form("lstNotifyName").Item
        dataTable.Add "notify_info", Request.Form("txtNotifyInfo").Item
        
        dataTable.Add "export_ref", Request.Form("txtExportRef").Item
        dataTable.Add "origin_country", Request.Form("txtOriginCountry").Item
        dataTable.Add "export_instr", Request.Form("txtExportInstr").Item
        dataTable.Add "pre_carriage", Request.Form("txtPreCarriage").Item
        dataTable.Add "pre_receipt_place", Request.Form("txtPreReceiptPlace").Item
        dataTable.Add "export_carrier", Request.Form("txtExportCarrier").Item
        dataTable.Add "loading_port", Request.Form("txtLoadingPort").Item
        dataTable.Add "loading_pier", Request.Form("txtLoadingPier").Item
        dataTable.Add "loading_terminal", Request.Form("txtLoadingTerminal").Item
        dataTable.Add "unloading_port", Request.Form("txtUnloadingPort").Item
        
        dataTable.Add "delivery_place", Request.Form("txtDeliveryPlace").Item
        dataTable.Add "move_type", Request.Form("txtMoveType").Item
        dataTable.Add "containerized", Request.Form("hContainerized").Item

        dataTable.Add "desc1", Request.Form("txtDesc1").Item
        dataTable.Add "desc2", Request.Form("txtDesc2").Item
        dataTable.Add "desc3", Request.Form("txtDesc3").Item
        dataTable.Add "gross_weight", Request.Form("txtGrossWeight").Item
        dataTable.Add "measurement", Request.Form("txtMeasurement").Item
        dataTable.Add "weight_scale", Request.Form("lstWeightScale").Item
        dataTable.Add "measurement_scale", Request.Form("lstMeasurementScale").Item
        dataTable.Add "us_state", Request.Form("txtUsState").Item
        dataTable.Add "ff_name", Request.Form("txtFFName").Item
        dataTable.Add "ff_city", Request.Form("txtFFCity").Item
        dataTable.Add "employee", Request.Form("txtPrepareBy").Item
        dataTable.Add "origin_state", Request.Form("txtOriginState").Item

        dataTable.Add "updated_date", Date()
        dataTable.Add "sworn_date", Request.Form("txtSwornDate").Item
        dataTable.Add "created_date", Request.Form("txtCreatedDate").Item
        dataTable.Add "ff_county_name", Request.Form("lstFFCounty").Item
        dataTable.Add "ff_county_acct", Request.Form("hFFCountyAcct").Item
        
        dataTable.Add "elt_account_number", elt_account_number
        dataTable.Add "session_id", Session.SessionID

        If ship_type = "O" Then
            If search_type <> "none" Then
                dataTable.Add "anonymous", "N"
                
                SQL = "SELECT * FROM certificate_origin_ocean WHERE elt_account_number=" & elt_account_number _
                    & " AND anonymous='N' AND session_id=N'" & Session.SessionID & "' "
                If search_type = "house" Then
                    SQL = SQL & "AND hbol_num=N'" & search_no & "'"
                End If
                If search_type = "master" Then
                    SQL = SQL & "AND booking_num=N'" & search_no & "'"
                End If
            Else
                dataTable.Add "file_name", Request.Form("txtFileName").Item
                dataTable.Add "anonymous", "Y"
                
                If Request.Form("txtFileName").Item <> "" Then
                    SQL = "SELECT * FROM certificate_origin_ocean WHERE elt_account_number=" & elt_account_number _
                        & " AND anonymous='Y' AND session_id=N'" & Session.SessionID _
                        & "' AND file_name=N'" & Request.Form("txtFileName").Item & "'"
                End If
            End If
            
            dataObj.SetColumnKeys("certificate_origin_ocean")
            If dataObj.UpdateDBRow(SQL,dataTable) Then
                cert_id = GetCertID(SQL)
                dataTable.Add "cert_id", cert_id
                SQL = "SELECT * FROM certificate_origin_ocean_items WHERE cert_id=" & cert_id
                dataObj.SetColumnKeys("certificate_origin_ocean_items")
                dataObj.UpdateDBRow SQL, dataTable
            End If
        Elseif ship_type = "A" Then
            If search_type <> "none" Then
                dataTable.Add "anonymous", "N"
                
                SQL = "SELECT * FROM certificate_origin_air WHERE elt_account_number=" & elt_account_number _
                    & " AND anonymous='N' AND session_id=N'" & Session.SessionID & "' "
                If search_type = "house" Then
                    SQL = SQL & "AND hawb_num=N'" & search_no & "'"
                End If
                If search_type = "master" Then
                    SQL = SQL & "AND mawb_num=N'" & search_no & "'"
                End If
            Else
                dataTable.Add "file_name", Request.Form("txtFileName").Item
                dataTable.Add "anonymous", "Y"
                
                If Request.Form("txtFileName").Item <> "" Then
                    SQL = "SELECT * FROM certificate_origin_air WHERE elt_account_number=" & elt_account_number _
                        & " AND anonymous='Y' AND session_id=N'" & Session.SessionID _
                        & "' AND file_name=N'" & Request.Form("txtFileName").Item & "'"
                End If
            End If
            
            dataObj.SetColumnKeys("certificate_origin_air")
            If dataObj.UpdateDBRow(SQL,dataTable) Then
            
                cert_id = GetCertID(SQL)
                
                dataTable.Add "cert_id", cert_id
                SQL = "SELECT * FROM certificate_origin_air_items WHERE cert_id=" & cert_id
                dataObj.SetColumnKeys("certificate_origin_air_items")
                dataObj.UpdateDBRow SQL, dataTable
            End If
        Else
        End If

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
    
    Function GetCertID(sqltxt)
        Dim returnVal,rs
        
        returnVal = -1

        Set rs = Server.CreateObject("ADODB.Recordset")
        rs.Open sqltxt,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

        If Not rs.EOF And Not rs.BOF Then
            returnVal = rs("auto_uid").value
        End If

        GetCertID = returnVal
        rs.close
    End Function
    
    Sub write_import_xml()
        Dim i
        Response.Expires = 0  
        Response.AddHeader "Pragma","no-cache"  
        Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
        Response.ContentType = "text/xml"
        Response.CharSet = "utf-8"
        
        Response.Write "<?xml version=""1.0"" encoding=""utf-8""?>"
        Response.Write "<FormDocument>"
        
        If search_type <> "none" Then
            If Not IsNull(search_list) And Not IsEmpty(search_list) Then
                For i=0 To search_list.count-1
                Response.Write "<item>"
                Response.Write "<value>" & encodeXMLCode(search_list(i)) & "</value>"
                Response.Write "<label>" & encodeXMLCode(search_list(i)) & "</label>"
                Response.Write "</item>"
                Next
            End If
            Response.Write "</FormDocument>"
        Else
            If Not IsNull(search_list) And Not IsEmpty(search_list) Then
                For i=0 To search_list.count-1
                Response.Write "<item>"
                Response.Write "<value>" & encodeXMLCode(search_list(i)) & "</value>"
                Response.Write "<label>" & encodeXMLCode(search_list(i)) & "</label>"
                Response.Write "</item>"
                Next
            End If
            Response.Write "</FormDocument>"
        End If
    End Sub
    
    Function get_none_array()
        Dim none_array,SQL,rs,tableName
        Set rs = Server.CreateObject("ADODB.Recordset")
        Set none_array = Server.CreateObject("System.Collections.ArrayList")

        If ship_type = "A" Then
            tableName = "certificate_origin_air"
        Else
            tableName = "certificate_origin_ocean"
        End If
        
        SQL = "SELECT DISTINCT " & topNum & " file_name FROM " & tableName & " WHERE " _
            & "elt_account_number=" & elt_account_number _
            & " AND anonymous='Y' AND file_name IS NOT NULL AND file_name!='' " _
            & "AND file_name LIKE N'" & qStr & "%' AND file_name>=N'" _
            & cursorStr & "' ORDER BY file_name"
        
        rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly,adLockReadOnly,adCmdText
	    Set rs.activeConnection = Nothing
        
	    Do While Not rs.eof And Not rs.bof
		    none_array.Add rs(0).value
		    rs.MoveNext
	    Loop
	    rs.Close
	    Set get_none_array = none_array
    End Function

    Function get_export_HAWB_list()
        Dim tempList,SQL,rs
        Set rs = Server.CreateObject("ADODB.Recordset")
	    Set tempList = Server.CreateObject("System.Collections.ArrayList")
	     
	    If ship_type = "A" Then
	        SQL = "SELECT DISTINCT " & topNum & " hawb_num FROM HAWB_master where elt_account_number=" _
		        & elt_account_number & " AND hawb_num LIKE N'" & qStr & "%' AND hawb_num>=N'" _
		        & cursorStr & "' and is_dome='N' ORDER BY hawb_num"
		Else
		    SQL = "SELECT DISTINCT " & topNum & " hbol_num FROM hbol_master where elt_account_number=" _
		        & elt_account_number & " AND hbol_num LIKE N'" & qStr & "%' AND hbol_num>=N'" _
		        & cursorStr & "' ORDER BY hbol_num"
		End If
		
        
        rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly,adLockReadOnly,adCmdText
	    Set rs.activeConnection = Nothing
	    
	    Do While Not rs.eof And Not rs.bof 
		    tempList.Add rs(0).value
		    rs.MoveNext
	    Loop
	    rs.Close
                
        Set get_export_HAWB_list = tempList
    End Function
    
    Function get_export_MAWB_list()
        Dim tempList,SQL,rs
        Set rs = Server.CreateObject("ADODB.Recordset")
	    Set tempList = Server.CreateObject("System.Collections.ArrayList")
	   
	    If ship_type = "A" Then
	        SQL = "SELECT DISTINCT " & topNum & " mawb_num FROM MAWB_master a "_
	            & "left outer join MAWB_NUMBER b ON "_
	            & "(a.mawb_num=b.mawb_no and a.elt_account_number=b.elt_account_number) " _
	            & "where mawb_num NOT IN (SELECT isnull(mawb_num,'') from HAWB_MASTER where " _
	            & "elt_account_number=" & elt_account_number & ") and " _
	            & "a.elt_account_number=" & elt_account_number & " and b.Status!='C' " _
	            & "AND mawb_num LIKE N'" & qStr & "%' AND a.mawb_num>=N'" _
		        & cursorStr & "' and a.is_dome='N' ORDER BY mawb_num"
	    Else
            SQL = "SELECT DISTINCT " & topNum & " a.booking_num FROM mbol_master a LEFT OUTER JOIN " _
		        & "ocean_booking_number b ON (a.booking_num=b.booking_num AND " _
		        & "a.elt_account_number=b.elt_account_number) " _
		        & "where a.booking_num NOT IN (SELECT isnull(booking_num,'') from hbol_master where " _
		        & "elt_account_number=" & elt_account_number & ") and " _
		        & "a.elt_account_number=" & elt_account_number & " and status!='C'" _
		        & "AND a.booking_num LIKE N'" & qStr & "%' AND a.booking_num>=N'" _
		        & cursorStr & "' ORDER BY a.booking_num"
	    End If
           'response.Write SQL
    'response.End   
        rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly,adLockReadOnly,adCmdText
	    Set rs.activeConnection = Nothing

	    Do While Not rs.eof And Not rs.bof 
		    tempList.Add rs(0).value
		    rs.MoveNext
	    Loop
	    rs.Close
            
     
        Set get_export_MAWB_list = tempList
    End Function
    
    Function get_export_booking_list()
        Dim tempList,SQL,rs
        Set rs = Server.CreateObject("ADODB.Recordset")
	    Set tempList = Server.CreateObject("System.Collections.ArrayList")
	    
	    If ship_type = "A" Then
	        SQL = "SELECT DISTINCT " & topNum & " mawb_no FROM mawb_number WHERE status<>'C' AND used='Y' " _
	            & "AND mawb_no not in (select distinct isnull(mawb_num,'') from hawb_master where elt_account_number=" _
	            & elt_account_number & ") AND elt_account_number=" & elt_account_number & " AND mawb_no LIKE N'" _
	            & qStr & "%' AND mawb_no>=N'" & cursorStr & "' AND is_dome='N' ORDER BY mawb_no"
	    Else
            SQL = "SELECT DISTINCT " & topNum & " booking_num FROM ocean_booking_number WHERE status<>'C' " _
                & "AND booking_num not in (select distinct isnull(booking_num,'') from hbol_master where elt_account_number=" _
	            & elt_account_number & ") AND elt_account_number=" & elt_account_number & " AND booking_num LIKE N'" _
	            & qStr & "%' AND booking_num>=N'" & cursorStr & "' ORDER BY booking_num"
	    End If
        
        rs.CursorLocation = adUseClient
	    rs.Open SQL, eltConn, adOpenForwardOnly,adLockReadOnly,adCmdText
	    Set rs.activeConnection = Nothing

	    Do While Not rs.eof And Not rs.bof 
		    tempList.Add rs(0).value
		    rs.MoveNext
	    Loop
	    rs.Close
                
        Set get_export_booking_list = tempList
    End Function
    
    
%>