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
    Dim vMode,vBill,vMasterType,qStr,topNum,cursorStr,vSQL,vHouseType,vSearchType

    vMode = checkBlank(Request.QueryString("mode"),"")
    vBill = checkBlank(Request.QueryString("bill"),null)
    
    vMasterType = checkBlank(Request.QueryString("mtype"),"") 
    vHouseType = checkBlank(Request.QueryString("htype"),"")
    vSearchType = checkBlank(Request.QueryString("stype"),"") 
    qStr = checkBlank(Request.QueryString("qStr"),"")
	topNum = checkBlank("TOP " & Request.QueryString("limit"),"")
	cursorStr = checkBlank(Request.QueryString("cursor"),"")
    
    If vMode = "view" Then
        Call get_booking_info()
    Elseif vMode = "list" Then
        If vMasterType = "DGB" Then '// Domestic Ground Master BL
            vSQL = "SELECT DISTINCT " & topNum & " a.mawb_no FROM mawb_number a " _
                & "LEFT OUTER JOIN mawb_master b ON (a.elt_account_number=b.elt_account_number AND a.mawb_no=b.mawb_num) " _
                & "LEFT OUTER JOIN hawb_master c ON (a.elt_account_number=c.elt_account_number AND a.mawb_no=c.mawb_num) " _
                & "WHERE a.elt_account_number=" & elt_account_number & " AND a.mawb_no like N'" & qStr & "%' AND a.mawb_no >=N'" & cursorStr & "'" _
                & " AND a.is_dome='Y'  AND isnull(a.master_type,'')='DG' AND a.status='B' order by a.mawb_no"
	        MakeListSub(vSQL)
	        
	    Elseif vMasterType = "DUB" Then '// Domestic All Master BL
	        vSQL = "SELECT DISTINCT " & topNum & " a.mawb_no FROM mawb_number a " _
                & "LEFT OUTER JOIN mawb_master b ON (a.elt_account_number=b.elt_account_number AND a.mawb_no=b.mawb_num) " _
                & "LEFT OUTER JOIN hawb_master c ON (a.elt_account_number=c.elt_account_number AND a.mawb_no=c.mawb_num) " _
                & "WHERE a.elt_account_number=" & elt_account_number & " AND a.mawb_no like N'" & qStr & "%' AND a.mawb_no >=N'" & cursorStr & "'" _
                & " AND a.is_dome='Y'  AND a.status='B' order by a.mawb_no"
	        MakeListSub(vSQL)
	        
	    Elseif vMasterType = "DIB" Then '// Domestic Inbound Master BL
	        vSQL = "SELECT DISTINCT " & topNum & " a.mawb_no FROM mawb_number a " _
                & "LEFT OUTER JOIN mawb_master b ON (a.elt_account_number=b.elt_account_number AND a.mawb_no=b.mawb_num) " _
                & "LEFT OUTER JOIN hawb_master c ON (a.elt_account_number=c.elt_account_number AND a.mawb_no=c.mawb_num) " _
                & "WHERE a.elt_account_number=" & elt_account_number & " AND a.mawb_no like N'" & qStr & "%' AND a.mawb_no >=N'" & cursorStr & "'" _
                & " AND a.is_dome='Y' AND a.is_inbound='Y' AND a.status='B' order by a.mawb_no"
	        MakeListSub(vSQL)
	        
	    Elseif vMAsterType = "IBN" Then '// International Booking Not Used
	        vSQL = "SELECT DISTINCT " & topNum & " a.mawb_no FROM mawb_number a " _
                & "LEFT OUTER JOIN mawb_master b ON (a.elt_account_number=b.elt_account_number AND a.mawb_no=b.mawb_num) " _
                & "LEFT OUTER JOIN hawb_master c ON (a.elt_account_number=c.elt_account_number AND a.mawb_no=c.mawb_num) " _
                & "WHERE b.mawb_num IS NULL AND c.mawb_num IS NULL AND " _
                & "a.elt_account_number=" & elt_account_number & " AND a.mawb_no like N'" & qStr & "%' AND a.mawb_no >=N'" & cursorStr & "'" _
                & " AND a.is_dome='N' AND a.status='B' AND a.used='N' "
            MakeListSub(vSQL)
            
	    Elseif vMAsterType = "OBN" Then '// Ocean Booking Not Used
	        vSQL = "SELECT DISTINCT " & topNum & " a.booking_num FROM ocean_booking_number a " _
                & "LEFT OUTER JOIN mbol_master b ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num) " _
                & "LEFT OUTER JOIN hbol_master c ON (a.elt_account_number=c.elt_account_number AND a.booking_num=c.booking_num) " _
                & " WHERE a.status='B' AND b.booking_num IS NULL AND c.booking_num IS NULL AND a.elt_account_number=" _
                & elt_account_number & " AND a.booking_num like N'" & qStr & "%' AND a.booking_num >=N'" & cursorStr & "'"
            MakeListSub(vSQL)
	    
	    Elseif vMAsterType = "IBY-DIRECT" Then '// International Booking Not Used
	        vSQL = "SELECT DISTINCT " & topNum & " a.mawb_no FROM mawb_number a " _
                & "LEFT OUTER JOIN mawb_master b ON (a.elt_account_number=b.elt_account_number AND a.mawb_no=b.mawb_num) " _
                & "LEFT OUTER JOIN hawb_master c ON (a.elt_account_number=c.elt_account_number AND a.mawb_no=c.mawb_num) " _
                & "WHERE b.mawb_num IS NOT NULL AND c.mawb_num IS NULL AND " _
                & "a.elt_account_number=" & elt_account_number & " AND a.mawb_no like N'" & qStr & "%' AND a.mawb_no >=N'" & cursorStr & "'" _
                & " AND a.is_dome='N' AND a.status='B' AND a.used='Y' "
            MakeListSub(vSQL)
        
        Elseif vMAsterType = "OBY-DIRECT" Then '// Ocean Booking Not Used
	        vSQL = "SELECT DISTINCT " & topNum & " a.booking_num FROM ocean_booking_number a " _
                & "LEFT OUTER JOIN mbol_master b ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num) " _
                & "LEFT OUTER JOIN hbol_master c ON (a.elt_account_number=c.elt_account_number AND a.booking_num=c.booking_num) " _
                & " WHERE a.status='B' AND b.booking_num IS NOT NULL AND c.booking_num IS NULL AND a.elt_account_number=" _
                & elt_account_number & " AND a.booking_num like N'" & qStr & "%' AND a.booking_num >=N'" & cursorStr & "'"
            MakeListSub(vSQL)
                  
	    Elseif vHouseType = "AECON" Then '// Air Export Consolidated Houses
	        vSQL = "SELECT DISTINCT " & topNum & " c.hawb_num FROM mawb_number a " _
                & "LEFT OUTER JOIN mawb_master b ON (a.elt_account_number=b.elt_account_number AND a.mawb_no=b.mawb_num) " _
                & "LEFT OUTER JOIN hawb_master c ON (a.elt_account_number=c.elt_account_number AND a.mawb_no=c.mawb_num) " _
                & "WHERE b.mawb_num IS NOT NULL AND c.mawb_num IS NOT NULL AND " _
                & "a.elt_account_number=" & elt_account_number & " AND a.mawb_no like N'" & qStr & "%' AND a.mawb_no >=N'" & cursorStr & "'" _
                & " AND a.is_dome='N' AND a.status='B' AND a.used='Y' "
            MakeListSub(vSQL)
	    Elseif vHouseType = "OECON" Then '// Ocean Export Consolidated Houses
	        vSQL = "SELECT DISTINCT " & topNum & " c.hbol_num FROM ocean_booking_number a " _
                & "LEFT OUTER JOIN mbol_master b ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num) " _
                & "LEFT OUTER JOIN hbol_master c ON (a.elt_account_number=c.elt_account_number AND a.booking_num=c.booking_num) " _
                & " WHERE a.status='B' AND b.booking_num IS NOT NULL AND c.booking_num IS NOT NULL AND a.elt_account_number=" _
                & elt_account_number & " AND a.booking_num like N'" & qStr & "%' AND a.booking_num >=N'" & cursorStr & "'"
            MakeListSub(vSQL)
	    Elseif vHouseType = "DOCON" Then '// Domestic Consolidated Houses
	        vSQL = "SELECT DISTINCT " & topNum & " c.hawb_num FROM mawb_number a " _
                & "LEFT OUTER JOIN mawb_master b ON (a.elt_account_number=b.elt_account_number AND a.mawb_no=b.mawb_num) " _
                & "LEFT OUTER JOIN hawb_master c ON (a.elt_account_number=c.elt_account_number AND a.mawb_no=c.mawb_num) " _
                & "WHERE b.mawb_num IS NOT NULL AND c.mawb_num IS NOT NULL AND " _
                & "a.elt_account_number=" & elt_account_number & " AND a.mawb_no like N'" & qStr & "%' AND a.mawb_no >=N'" & cursorStr & "'" _
                & " AND a.is_dome='Y' AND a.status='B' AND a.used='Y' "
            MakeListSub(vSQL)
	    End If
	    
    End If
    
    Sub get_booking_info()
        Dim SQL,dataObj,dataTable
        SQL = ""

        If vSearchType = "domestic_master" Then
            SQL = "SELECT TOP 1 a.*,b.*,c.*,d.dba_name AS Customer_Name FROM mawb_number a FULL OUTER JOIN mawb_master b " _
                & "ON (a.mawb_no=b.mawb_num and a.elt_account_number=b.elt_account_number) " _
                & "FULL OUTER JOIN mawb_weight_charge c " _
                & "ON (a.mawb_no=c.mawb_num and a.elt_account_number=c.elt_account_number) " _ 
                & "FULL OUTER JOIN organization d ON (ISNULL(a.inbound_customer_acct,0) = ISNULL(d.org_account_number,0) " _
                & "AND a.elt_account_number=d.elt_account_number)" _
                & "WHERE (a.is_dome='Y' or a.is_dome='') AND a.elt_account_number=" _ 
                & elt_account_number & " AND a.mawb_no=N'" & vBill & "'"
        
        Elseif vSearchType = "air_master" Then
            SQL = "SELECT mawb_no AS master_num,'' AS house_num,File# AS file_num FROM mawb_number WHERE elt_account_number=" _
                & elt_account_number & " AND mawb_no=N'" & vBill & "'"
        Elseif vSearchType = "ocean_master" Then
            SQL = "SELECT booking_num AS master_num,'' AS house_num,file_no AS file_num FROM ocean_booking_number WHERE elt_account_number=" _
                & elt_account_number & " AND booking_num=N'" & vBill & "'"
        Elseif vSearchType = "air_house" Then
            SQL = "SELECT a.mawb_num AS master_num,a.hawb_num AS house_num,b.File# AS file_num FROM hawb_master a " _
                & "LEFT OUTER JOIN mawb_number b ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_no) WHERE a.elt_account_number=" _
                & elt_account_number & " AND a.hawb_num=N'" & vBill & "' AND a.is_dome='N'"
        Elseif vSearchType = "domestic_house" Then
            SQL = "SELECT a.mawb_num AS master_num,a.hawb_num AS house_num,b.File# AS file_num FROM hawb_master a " _
                & "LEFT OUTER JOIN mawb_number b ON (a.elt_account_number=b.elt_account_number AND a.mawb_num=b.mawb_no) WHERE a.elt_account_number=" _
                & elt_account_number & " AND a.hawb_num=N'" & vBill & "' AND a.is_dome='Y'"
        Elseif vSearchType = "ocean_house" Then
            SQL = "SELECT a.booking_num AS master_num,a.hbol_num AS house_num,b.file_no AS file_num FROM hbol_master a " _
                & "LEFT OUTER JOIN ocean_booking_number b ON (a.elt_account_number=b.elt_account_number AND a.booking_num=b.booking_num) WHERE a.elt_account_number=" _
                & elt_account_number & " AND a.hbol_num=N'" & vBill & "'"
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
        If dataObj.DataList.Count > 0 Then
            Response.Write(MakeXMLString(dataTable,dataObj.GetKeyArray()))
        End If
        Response.Write "</FormDocument>"
        
    End Sub
    
    Sub MakeListSub(vSQL)
        Dim rs
        
        Set rs = Server.CreateObject("ADODB.Recordset")
	    rs.CursorLocation = adUseClient	
	    rs.Open vSQL, eltConn, adOpenForwardOnly, adLockReadOnly, adCmdText
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
            Response.Write "<value>" & rs(0).value & "</value>"
            Response.Write "<label>" & rs(0).value & "</label>"
            Response.Write "</item>"
            rs.MoveNext
	    Loop
        Response.Write "</FormDocument>"
        rs.Close()
    End Sub
    
%>