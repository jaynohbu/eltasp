<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!-- #INCLUDE VIRTUAL="/ASP/include/connection.asp" -->
<!-- #INCLUDE VIRTUAL="/ASP/include/GOOFY_Util_fun.inc" -->
<% 
    Dim biz_type,elt_account_number,login_name,UserRight,orgList,i,qStr

    biz_type = Request.QueryString("oType").Item
    qStr = Request.QueryString("qStr").Item
    
    Dim TopNum,cursorName
    topNum = Request.QueryString("limit").Item
    cursorName = Request.QueryString("cursor").Item
    
    elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
    
    '// login_name = Request.Cookies("CurrentUserInfo")("login_name")
    '// UserRight = Request.Cookies("CurrentUserInfo")("user_right")	

    '// Set eltConn = Server.CreateObject("ADODB.Connection")
    '// eltConn.CursorLocation = adUseClient
    '// eltConn.Open "Provider=SQLOLEDB; Data Source=.; Initial Catalog=DEVDB; User ID=sa; Password="

    Set orgList = Server.CreateObject("System.Collections.ArrayList")
    Set orgList = get_organization_list(biz_type)

    Response.Expires = 0  
    Response.AddHeader "Pragma","no-cache"  
    Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
    Response.ContentType = "text/xml"
    Response.CharSet = "utf-8"
    Response.Write "<?xml version=""1.0"" encoding=""utf-8""?>"
    Response.Write "<FormDocument>"
    For i=0 To orgList.Count-1
        Response.Write "<item>"
        Response.Write "<value>" & encodeXMLCode(orgList(i)("acct")) & "</value>"
        Response.Write "<label>" & encodeXMLCode(RemoveQuotations(orgList(i)("name"))) & "</label>"
        Response.Write "</item>"
    Next
    Response.Write "</FormDocument>"

    Function get_organization_list(org_type)
        Dim returnList,tempTable,SQL,rs
        
        Set returnList = Server.CreateObject("System.Collections.ArrayList")
        Set tempTable = Server.CreateObject("System.Collections.HashTable")
        Set rs = Server.CreateObject("ADODB.Recordset")
        
        If Not IsNull(topNum) And topNum <> "" Then
            SQL = "SELECT TOP " & topNum & " org_account_number, " _
                & "CASE WHEN isnull(class_code,'') = '' THEN dba_name " _
                & "ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']' " _
                & "END as dba_name FROM organization where elt_account_number = " & elt_account_number _
                & " AND dba_name >= N'" & cursorName & "'"
        Else
            SQL = "SELECT org_account_number, " _
                & "CASE WHEN isnull(class_code,'') = '' THEN dba_name " _
                & "ELSE dba_name + '[' + RTRIM(LTRIM(isnull(class_code,''))) + ']' " _
                & "END as dba_name FROM organization where elt_account_number = " & elt_account_number 
        End If
        

        Select case org_type
            case "Shipper" 
                SQL = SQL & " AND is_shipper='Y' "
            case "ShipperAgent" 
                SQL = SQL & " AND (is_shipper='Y' OR is_agent='Y') "
            case "Consignee" 
                SQL = SQL & " AND (is_consignee='Y' OR is_shipper='Y') "
            case "Notify"
                SQL = SQL & " AND (is_consignee='Y' OR is_shipper='Y' OR is_agent='Y') "
            case "Carrier" 
                SQL = SQL & " AND is_carrier='Y' "
            case "Agent" 
                SQL = SQL & " AND is_agent='Y' "
            case "Trucker" 
                SQL = SQL & " AND z_is_trucker='Y' "
            case "Government"
                SQL = SQL & " AND z_is_govt='Y' "
            case "Broker"
                SQL = SQL & " AND z_is_broker='Y' "
            case "Pickup"
                SQL = SQL & " AND (is_consignee='Y' OR is_shipper='Y') "
            case "CarrierWarehouse"
                SQL = SQL & " AND (is_carrier='Y' OR z_is_warehousing='Y') "
            case "Customer"
                SQL = SQL & " AND (is_shipper='Y' OR is_consignee='Y' OR is_agent='Y' OR z_is_govt='Y' OR z_is_broker='Y' OR is_customer='Y') "
            case "Vendor"
                SQL = SQL & " AND (is_vendor = 'Y' or z_is_trucker = 'Y' or z_is_govt = 'Y' or z_is_special = 'Y' or z_is_broker='Y' or z_is_warehousing='Y' or is_agent='Y') "
            case "Vendor Only"
                SQL = SQL & " AND Is_Vendor='Y' "
        End Select
        
        If qStr <> "" Then
            SQL = SQL & " AND UPPER(dba_name) LIKE N'" & UCase(RemoveQuotations(qStr)) & "%'"
        End If
        
        SQL = SQL & " AND isnull(account_status,'A')<>'C' ORDER BY dba_name"
        
        
        eltConn.CursorLocation = adUseNone
	    rs.CursorLocation = adUseClient	
	    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
        Set rs.ActiveConnection = Nothing

        Do While Not rs.EOF and NOT rs.bof
            Set tempTable = Server.CreateObject("System.Collections.HashTable")
            tempTable.Add "acct", rs("org_account_number").value
            tempTable.Add "name", rs("dba_name").value
            returnList.Add tempTable
		    rs.MoveNext
	    Loop
        
        rs.Close
	    Set rs = Nothing
        Set get_organization_list = returnList
    End Function
    
%>