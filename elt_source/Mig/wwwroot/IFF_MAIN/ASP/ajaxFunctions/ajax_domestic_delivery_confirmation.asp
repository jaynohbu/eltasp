<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% Option Explicit %>
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
	
    Dim search_type,search_no,ship_type,dataObj,mode,search_list,qStr,topNum,cursorStr
    
    search_type = checkBlank(Request.QueryString("type"),"")
    search_no = checkBlank(Request.QueryString("no"),"")
    ship_type = checkBlank(Request.QueryString("export"),"")
    mode = checkBlank(Request.QueryString("mode"),"")
    qStr = checkBlank(Request.QueryString("qStr"),"")
    topNum = checkBlank("TOP " & Request.QueryString("limit"),"")
    cursorStr = checkBlank(Request.QueryString("cursor"),"")
    
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
        End If
    Elseif mode = "list" Then
        If search_type = "house" Then
            Set search_list = get_export_HAWB_list()
        Elseif search_type = "master" Then
            Set search_list = get_export_MAWB_list()
        Elseif search_type = "file" Then
            Set search_list = get_export_file_list()
        Else
        End If
        Call write_import_xml()
    Else
	End If

    
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
            
        Elseif search_type = "file" Then
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
        
        If search_type <> "file" Then
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
    

    Function get_export_HAWB_list()
        Dim tempList,SQL,rs
        Set rs = Server.CreateObject("ADODB.Recordset")
	    Set tempList = Server.CreateObject("System.Collections.ArrayList")
	    
	    If ship_type = "A" Then
	        SQL = "SELECT DISTINCT " & topNum & " hawb_num FROM HAWB_master where elt_account_number=" _
		        & elt_account_number & "  and is_dome='Y'and isnull(shipper_account_number,0)<>0 ORDER BY hawb_num"
		End If
		
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

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
	    SQL = "SELECT DISTINCT " & topNum & " a.mawb_no from mawb_number a inner join mawb_master b on (a.mawb_no=b.mawb_num and a.elt_account_number=b.elt_account_number) " _
            & "where a.is_dome='Y' and a.status='B' and a.elt_account_number=" & elt_account_number & " and isnull(b.Shipper_account_number,0)<>0 order by a.mawb_no"

	    End If

	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

	    Do While Not rs.eof And Not rs.bof 
		    tempList.Add rs(0).value
		    rs.MoveNext
	    Loop
	    rs.Close
        Set get_export_MAWB_list = tempList
    End Function

Function get_export_file_list()
        Dim tempList,SQL,rs
        Set rs = Server.CreateObject("ADODB.Recordset")
	    Set tempList = Server.CreateObject("System.Collections.ArrayList")
	    
	    If ship_type = "A" Then
	      SQL = "SELECT  a.file# from mawb_number a inner join mawb_master b on (a.mawb_no=b.mawb_num and a.elt_account_number=b.elt_account_number) " _
            & "where a.is_dome='Y' and a.status='B' and a.elt_account_number=" & elt_account_number & " and isnull(b.Shipper_account_number,0)<>0 and isnull(a.file#,'') <> '' order by a.mawb_no"

	    End If

	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText

	    Do While Not rs.eof And Not rs.bof 
		    tempList.Add rs(0).value
		    rs.MoveNext
	    Loop
	    rs.Close
        Set get_export_file_list = tempList
    End Function
    
%>