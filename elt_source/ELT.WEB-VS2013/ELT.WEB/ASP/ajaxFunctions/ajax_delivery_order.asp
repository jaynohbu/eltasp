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
	
    Dim search_type,ship_type,dataObj,mode,house_num,master_num,sec_num,file_name,search_list,qStr,topNum,cursorStr
    
    search_type = checkBlank(Request.QueryString("type"),"")
    ship_type = checkBlank(Request.QueryString("import"),"")
    mode = checkBlank(Request.QueryString("mode"),"")
    house_num = checkBlank(Request.QueryString("hawb"),"")
    master_num = checkBlank(Request.QueryString("mawb"),"")
    sec_num = checkBlank(Request.QueryString("sec"),"")
    qStr = checkBlank(Request.QueryString("qStr"),"")
    topNum = checkBlank("TOP " & Request.QueryString("limit"),"")
    cursorStr = checkBlank(Request.QueryString("cursor"),"")
    
	If checkBlank(Request.QueryString("file"),"") = "" Or mode = "update" Then
		file_name = checkBlank(Request.Form("txtFileName").Item,"")
	Else
		file_name = Request.QueryString("file")
	End If

	If house_num = "" And master_num = "" And sec_num = "" And file_name = "" And mode <> "list" Then
		If mode = "view" Then
			Call get_empty_info()
		Else
			Response.Write("Please, validate the form first.")
		End If
		mode = ""
	End If

    If mode = "view" Then
        If ship_type = "A" Then
            Call get_all_info()
        Elseif ship_type = "O" Then
			Call get_all_info()
        Else
        End If
    Elseif mode = "update" Then
		If save_to_table() Then
			If search_type = "house" Then
				Response.Write("House No. '" & house_num & "' has been updated successfully")
		    Elseif search_type = "master" Then
		        Response.Write("Master/Booking No. '" & master_num & "' has been updated successfully")
			Else
				Response.Write("Anonymous file '" & file_name & "' has been updated successfully")
			End If
		Else
			If search_type = "house" Then
				Response.Write("Failed to update House No. '" & house_num & "'")
		    Elseif search_type = "master" Then
		        Response.Write("Master/Boooking No. '" & master_num & "' has been updated successfully")
			Else
				Response.Write("Failed to update Anonymous file '" & file_name & "'")
			End If
		End If

    Elseif mode = "delete" Then
        If delete_from_table() Then
            Response.Write("Anonymous file '" & file_name & "' has been deleted successfully")
        Else
            Response.Write("Failed to delete Anonymous file '" & file_name & "'")
        End If
        
    Elseif mode = "list" Then
        If search_type = "house" Then
            Set search_list = get_import_HAWB_list()
        Elseif search_type = "master" Then
            Set search_list = get_import_MAWB_list()
        Elseif search_type = "none" Then
            Set search_list = get_none_array()
        Else
        End If
        Call write_import_xml()
    Else
    End If
    
    Function save_to_table()
    
        Dim SQL,dataTable,i,resVal
        resVal = False
        
        Set dataObj = new DataManager
        Set dataTable = Server.CreateObject("System.Collections.HashTable")

        dataTable.Add "update_date" , Date()
        dataTable.Add "ref_no_Our" , Request.Form("txtRefNoOur").Item
        dataTable.Add "carrier_name" , Request.Form("lstCarrierName").Item
        dataTable.Add "carrier_code" , Request.Form("hCarrierCode").Item
        dataTable.Add "carrier_acct" , Request.Form("hCarrierAcct").Item
        dataTable.Add "carrier_info" , Request.Form("txtCarrierInfo").Item
        dataTable.Add "importer_name" , Request.Form("lstImporterName").Item
        dataTable.Add "importer_acct" , Request.Form("hImporterAcct").Item
        dataTable.Add "importer_info" , Request.Form("txtImporterInfo").Item    
        dataTable.Add "mawb_no" , Request.Form("txtMAWB").Item
        dataTable.Add "hawb_no" , Request.Form("txtHAWB").Item
        dataTable.Add "sec_num" , Request.Form("hSecNum").Item
        dataTable.Add "cargo_location" , Request.Form("lstCargoLocation").Item
        dataTable.Add "sub_hawb_no" , Request.Form("txtSubHAWB").Item
        dataTable.Add "entry_billing_no" , Request.Form("txtEntryBilling").Item
        dataTable.Add "customer_ref_no" , Request.Form("txtCustomerRef").Item
        dataTable.Add "eta" , Request.Form("txtArrDate").Item
        dataTable.Add "etd" , Request.Form("txtDepDate").Item
        dataTable.Add "free_date" , Request.Form("txtFreeDate").Item
        dataTable.Add "dep_port_code" , Request.Form("lstDepPort").Item
        dataTable.Add "arr_port_code" , Request.Form("lstArrPort").Item
        dataTable.Add "pickup_name" , Request.Form("lstPickupName").Item
        dataTable.Add "pickup_info" , Request.Form("txtPickupInfo").Item
        dataTable.Add "pickup_acct" , Request.Form("hPickupAcct").Item
        dataTable.Add "trucker_name" , Request.Form("lstTruckerName").Item
        dataTable.Add "trucker_info" , Request.Form("txtTruckerInfo").Item
        dataTable.Add "trucker_acct" , Request.Form("hTruckerAcct").Item
        dataTable.Add "attention" , Request.Form("txtAttention").Item
        dataTable.Add "consignee_acct" , Request.Form("hConsigneeAcct").Item
        dataTable.Add "consignee_name" , Request.Form("lstConsigneeName").Item
        dataTable.Add "consignee_info" , Request.Form("txtConsigneeInfo").Item
        dataTable.Add "route" , Request.Form("txtRoute").Item
        dataTable.Add "handling" , Request.Form("txtHandling").Item
        dataTable.Add "item_pieces" , Request.Form("txtPieces").Item
        dataTable.Add "item_desc" , Request.Form("txtDesc3").Item
        dataTable.Add "item_scale" , Request.Form("lstScale1").Item
        dataTable.Add "item_gross_wt" , Request.Form("txtGrossWt").Item
        dataTable.Add "dimension" , Request.Form("txtDimension").Item
        dataTable.Add "dimension_scale" , Request.Form("lstDimScale").Item
        dataTable.Add "inland_charge" , Request.Form("txtInlandCharge").Item
        dataTable.Add "inland_charge_type" , Request.Form("hInlandChargeType").Item 
        dataTable.Add "delivery_ref_num" , Request.Form("txtDeliveryRefNum").Item 
        dataTable.Add "employee" , Request.Form("txtEmployee").Item
        dataTable.Add "iType", ship_type
        dataTable.Add "elt_account_number", elt_account_number
        dataTable.Add "session_id", Session.SessionID

        If search_type <> "none" Then
            dataTable.Add "anonymous", "N"
            SQL = "SELECT * FROM delivery_order WHERE elt_account_number=" & elt_account_number _
                & " AND anonymous='N' AND session_id=N'" & Session.SessionID & "' AND iType=N'" _
                & ship_type & "'" & " AND hawb_no=N'" & Request.Form("txtHAWB").Item & "'" _
                & " AND mawb_no=N'" & Request.Form("txtMAWB").Item & "' AND sec_num=N'" _
                & Request.Form("hSecNum").Item & "'"
        Else
            dataTable.Add "file_name", Request.Form("txtFileName").Item
            dataTable.Add "anonymous", "Y"
            If Request.Form("txtFileName").Item <> "" Then
                SQL = "SELECT * FROM delivery_order WHERE elt_account_number=" & elt_account_number _
                    & " AND anonymous='Y' AND session_id=N'" & Session.SessionID & "' AND iType=N'" _
                    & ship_type & "' AND file_name=N'" & Request.Form("txtFileName").Item & "'"
            End If
        End If

        dataObj.SetColumnKeys("delivery_order")
        resVal = dataObj.UpdateDBRow(SQL, dataTable)
        
        save_to_table = resVal
    End Function
    
    Sub get_all_info()
        Dim SQL,dataTable

	    If search_type = "house" Or search_type = "master" Then
	        SQL = "SELECT TOP 1 * FROM delivery_order WHERE elt_account_number=" & elt_account_number _
			    & " AND ISNULL(hawb_no,'')=N'" & house_num & "' AND ISNULL(mawb_no,'')=N'" & master_num & "' AND sec_num=N'" _
			    & sec_num & "' AND iType=N'" & ship_type & "' ORDER BY auto_uid DESC"
			    
            If IsEmptyRS(SQL) Then
		        SQL = "SELECT a.elt_account_number as elt_account_number," _
		            & "a.mawb_num as mawb_no,a.hawb_num as hawb_no,a.igSub_HAWB as sub_hawb_no," _
		            & "a.shipper_name as shipper_name,a.shipper_info as shipper_info," _
		            & "a.shipper_acct as shipper_acct,a.consignee_name as consignee_name," _
		            & "a.consignee_info as consignee_info,a.consignee_acct as consignee_acct," _
		            & "a.CreatedDate as update_date,b.carrier as carrier_name," _
		            & "b.carrier_code as carrier_code,a.cargo_location,b.iType as iType," _
		            & "a.eta,a.etd,b.last_free_date as free_date,a.customer_ref as customer_ref_no," _
		            & "a.pieces as item_pieces,a.desc3 as item_desc,a.gross_wt as item_gross_wt," _
		            & "a.scale1 as item_scale,a.sec as sec_num,c.ref_no_Our,charge_amount as inland_charge," _
		            & "a.dep_code as dep_port_code,a.arr_code as arr_port_code," _
		            & "a.chg_wt as dimension,a.scale2 as dimension_scale " _
                    & "FROM import_hawb a,import_mawb b,invoice c,invoice_charge_item d,item_charge e WHERE " _
                    & "a.mawb_num=b.mawb_num AND a.elt_account_number=b.elt_account_number AND " _
                    & "a.invoice_no = c.invoice_no AND a.elt_account_number = c.elt_account_number AND " _
                    & "d.invoice_no = a.invoice_no AND a.elt_account_number = d.elt_account_number AND " _
                    & "a.elt_account_number = e.elt_account_number AND d.item_no = e.item_no AND " _
                    & "a.elt_account_number=" & elt_account_number & " AND a.hawb_num=N'" & house_num _
                    & "' AND a.sec=N'" & sec_num & "' AND a.mawb_num=N'" & master_num & "' AND e.item_name='IF'"
                If IsEmptyRS(SQL) Then 
                    SQL = "SELECT TOP 1 a.elt_account_number as elt_account_number," _
		                & "a.mawb_num as mawb_no,a.hawb_num as hawb_no,a.igSub_HAWB as sub_hawb_no," _
		                & "a.shipper_name as shipper_name,a.shipper_info as shipper_info," _
		                & "a.shipper_acct as shipper_acct,a.consignee_name as consignee_name," _
		                & "a.consignee_info as consignee_info,a.consignee_acct as consignee_acct," _
		                & "a.CreatedDate as update_date,b.carrier as carrier_name," _
		                & "b.carrier_code as carrier_code,a.cargo_location,b.iType as iType," _
		                & "a.eta,a.etd,b.last_free_date as free_date,a.customer_ref as customer_ref_no," _
		                & "a.pieces as item_pieces,a.desc3 as item_desc,a.gross_wt as item_gross_wt," _
		                & "a.scale1 as item_scale,a.sec as sec_num,c.ref_no_Our, 0 as inland_charge," _
		                & "a.dep_code as dep_port_code,a.arr_code as arr_port_code," _
		                & "a.chg_wt as dimension,a.scale2 as dimension_scale " _
                        & "FROM import_hawb a,import_mawb b,invoice c WHERE " _
                        & "a.mawb_num=b.mawb_num AND a.elt_account_number=b.elt_account_number AND " _
                        & "a.invoice_no = c.invoice_no AND a.elt_account_number = c.elt_account_number AND " _
                        & "a.elt_account_number=" & elt_account_number & " AND a.hawb_num=N'" & house_num _
                        & "' AND a.sec=N'" & sec_num & "' AND a.mawb_num=N'" & master_num & "'"
                    If IsEmptyRS(SQL) Then 
                        SQL = "SELECT TOP 1 a.elt_account_number as elt_account_number," _
		                    & "a.mawb_num as mawb_no,a.hawb_num as hawb_no,a.igSub_HAWB as sub_hawb_no," _
		                    & "a.shipper_name as shipper_name,a.shipper_info as shipper_info," _
		                    & "a.shipper_acct as shipper_acct,a.consignee_name as consignee_name," _
		                    & "a.consignee_info as consignee_info,a.consignee_acct as consignee_acct," _
		                    & "a.CreatedDate as update_date,b.carrier as carrier_name," _
		                    & "b.carrier_code as carrier_code,a.cargo_location,b.iType as iType," _
		                    & "a.eta,a.etd,b.last_free_date as free_date,a.customer_ref as customer_ref_no," _
		                    & "a.pieces as item_pieces,a.desc3 as item_desc,a.gross_wt as item_gross_wt," _
		                    & "a.scale1 as item_scale,a.sec as sec_num,'' as ref_no_Our, 0 as inland_charge," _
                            & "a.dep_code as dep_port_code,a.arr_code as arr_port_code," _
		                    & "a.chg_wt as dimension,a.scale2 as dimension_scale " _
                            & "FROM import_hawb a,import_mawb b WHERE " _
                            & "a.mawb_num=b.mawb_num AND a.elt_account_number=b.elt_account_number AND " _
                            & "a.elt_account_number=" & elt_account_number & " AND a.hawb_num=N'" & house_num _
                            & "' AND a.sec=N'" & sec_num & "' AND a.mawb_num=N'" & master_num & "'"
                    End If
                End If
			End If
	    Elseif search_type = "none" Then
	        SQL = "SELECT TOP 1 * FROM delivery_order WHERE elt_account_number=" & elt_account_number _
	            & " AND file_name=N'" & file_name & "' AND anonymous='Y' AND iType=N'" & ship_type _
	            & "' ORDER BY auto_uid DESC"
	    Else  
		End If


        Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set dataTable = dataObj.GetRowTable(0)

        Dim cargo_temp,pos_cargo
        cargo_temp = checkBlank(dataTable("cargo_location"),"")
        pos_cargo = InStr(1,cargo_temp,"-")
        If pos_cargo>0 Then
            cargo_temp = Mid(cargo_temp,1,pos_cargo-1)
        End If
        dataTable("cargo_location") = cargo_temp
        
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
        
        Dim carrier_address
        
        If checkBlank(dataTable("carrier_code"),"") <> "" Then
            carrier_address = GetCarrierAddress(dataTable("carrier_code"))
            Dim pos
            pos = InStr(1,carrier_address,"-")
            If pos > 0 Then
                Response.Write "<carrier_acct>" & Mid(carrier_address,1,pos-1) & "</carrier_acct>"
                Response.Write "<carrier_info>" & encodeXMLCode(Mid(carrier_address,pos+1)) & "</carrier_info>"
            
                Response.Write "<pickup_acct>" & Mid(carrier_address,1,pos-1) & "</pickup_acct>"     
                Response.Write "<pickup_name>" & dataTable("carrier_name") & "</pickup_name>"       
                Response.Write "<pickup_info>" & encodeXMLCode(Mid(carrier_address,pos+1)) & "</pickup_info>"
            End If
        End If

        Response.Write "</FormDocument>"
        
    End Sub
    
	Sub get_empty_info()
		Dim SQL,dataTable
		Set dataObj = new DataManager
		SQL = "SELECT TOP 0 * FROM delivery_order"
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

    Function delete_from_table()
        Dim SQL,rs,resVal
        resVal = False
        
        If checkBlank(file_name,"") <> "" Then
            SQL = "DELETE FROM delivery_order WHERE file_name=N'" & file_name & "' AND " _
                & "elt_account_number=" & elt_account_number & " AND anonymous='Y'"
            Set rs = Server.CreateObject("ADODB.Recordset")
            
			On Error Resume Next:
			Set rs = eltConn.execute(SQL)
            
            If eltConn.Errors.Count = 0 then
                resVal = True
            End If
        End If
        delete_from_table = resVal
    End Function
    
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
    
    Function GetCarrierAddress(cCode)
    
        Dim returnVal,SQL,rs
        returnVal = ""
        On Error Resume Next:
        Set rs = Server.CreateObject("ADODB.Recordset")
        SQL= "SELECT * FROM organization WHERE elt_account_number = " & elt_account_number _
		    & " AND is_carrier='Y' AND carrier_code=" & cCode
    		
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
    	
	    If Not rs.EOF AND Not rs.BOF Then
            If checkBlank(rs("business_State").value,"")="" Then
                returnVal = rs("org_account_number").value & "-" & rs("DBA_NAME").value _
				    & chr(10) & rs("business_address").value & chr(10) & rs("business_city").value _
				    & "," & rs("business_Country").value & chr(10) 
		    Else
                returnVal = rs("org_account_number").value & "-" & rs("DBA_NAME").value _
				    & chr(10) & rs("business_address").value & chr(10) & rs("business_city").value _
				    & "," & rs("business_State").value & " " & rs("business_Zip").value _
				    & "," & rs("business_Country").value & chr(10) 
		    End If
    		
		    If Not IsNull(rs("business_phone")) And Trim(rs("business_phone")) <> "" Then
	            returnVal = returnVal & "Tel:" & rs("business_phone") & " "
	        End If
	        If Not IsNull(rs("business_fax")) And Trim(rs("business_fax")) <> "" Then
	            returnVal = returnVal & "Fax:" & rs("business_fax") & " "
	        End If
    	    
	    End If
        rs.close
        
        GetCarrierAddress = returnVal
        
    End Function
    
    Function get_import_HAWB_list()

	    Dim hawb_table,hawb_array,SQL,rs
	    Set hawb_array = Server.CreateObject("System.Collections.ArrayList")

	    SQL = "SELECT DISTINCT " & topNum & " a.hawb_num,a.mawb_num,a.sec FROM import_hawb a "_
		    & "LEFT OUTER JOIN import_mawb b ON (a.mawb_num=b.mawb_num and " _
		    & "a.elt_account_number=b.elt_account_number) "_
		    & "WHERE a.elt_account_number='" & elt_account_number & "' AND " _
		    & "a.iType=N'" & ship_type & "' AND hawb_num like N'" & qStr _
		    & "%' AND ISNULL(a.hawb_num,'')<>'' AND a.hawb_num>=N'" _
            & cursorStr & "'ORDER BY a.hawb_num"
	    Set rs = eltConn.execute(SQL)

	    Do While Not rs.EOF and NOT rs.bof

		    Set hawb_table = Server.CreateObject("System.Collections.HashTable")
		    hawb_table.Add "key", checkBlank(rs("hawb_num").value,"Anonymous") _
		        & " (" & rs("mawb_num").value & ")"
		    hawb_table.Add "hawb", checkBlank(rs("hawb_num").value,"")
		    hawb_table.Add "mawb", rs("mawb_num").value
		    hawb_table.Add "sec", rs("sec").value
		    rs.MoveNext
		    hawb_array.Add hawb_table
	    Loop
        rs.Close
        
        Set get_import_HAWB_list = hawb_array
        
    End Function
    
    Function get_import_MAWB_list()

	    Dim hawb_table,hawb_array,SQL,rs
	    Set hawb_array = Server.CreateObject("System.Collections.ArrayList")

	    SQL = "SELECT DISTINCT " & topNum & " a.hawb_num,a.mawb_num,a.sec FROM import_hawb a "_
		    & "LEFT OUTER JOIN import_mawb b ON (a.mawb_num=b.mawb_num and " _
		    & "a.elt_account_number=b.elt_account_number) "_
		    & "WHERE a.elt_account_number='" & elt_account_number & "' AND " _
		    & "a.iType=N'" & ship_type & "' AND a.mawb_num like N'" & qStr _
		    & "%' AND ISNULL(a.hawb_num,'')='' AND a.mawb_num>=N'" _
            & cursorStr & "' ORDER BY a.mawb_num"

	    Set rs = eltConn.execute(SQL)

	    Do While Not rs.EOF and NOT rs.bof

		    Set hawb_table = Server.CreateObject("System.Collections.HashTable")
		    hawb_table.Add "key", rs("mawb_num").value 
		    hawb_table.Add "hawb", checkBlank(rs("hawb_num").value,"")
		    hawb_table.Add "mawb", rs("mawb_num").value
		    hawb_table.Add "sec", rs("sec").value
		    rs.MoveNext
		    hawb_array.Add hawb_table
	    Loop
        rs.Close
        
        Set get_import_MAWB_list = hawb_array
        
    End Function
    
    Function get_none_array()
        Dim none_array,SQL,rs
        Set rs = Server.CreateObject("ADODB.Recordset")
        Set none_array = Server.CreateObject("System.Collections.ArrayList")

        SQL = "SELECT DISTINCT " & topNum & " file_name FROM delivery_order where " _
            & "elt_account_number=" & elt_account_number  & " AND iType=N'" & ship_type _
            & "' AND anonymous='Y' AND file_name IS NOT NULL AND file_name!='' " _
            & "AND file_name like N'" & qStr & "%' AND file_name>=N'" _
            & cursorStr & "' ORDER BY file_name"

        rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        
	    Do While Not rs.eof And Not rs.bof
		    none_array.Add rs("file_name").value
		    rs.MoveNext
	    Loop
	    rs.Close
	    Set get_none_array = none_array
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
                Response.Write "<value>" & encodeXMLCode("hawb=" & search_list(i)("hawb") & "&mawb=" & search_list(i)("mawb") & "&sec=" & search_list(i)("sec")) & "</value>"
                Response.Write "<label>" & encodeXMLCode(search_list(i)("key")) & "</label>"
                Response.Write "</item>"
                Next
            End If
            Response.Write "</FormDocument>"
        Else
            If Not IsNull(search_list) And Not IsEmpty(search_list) Then
                For i=0 To search_list.count-1
                Response.Write "<item>"
                Response.Write "<value>" & encodeXMLCode("file=" & search_list(i)) & "</value>"
                Response.Write "<label>" & encodeXMLCode(search_list(i)) & "</label>"
                Response.Write "</item>"
                Next
            End If
            Response.Write "</FormDocument>"
        End If
    End Sub
    

%>

