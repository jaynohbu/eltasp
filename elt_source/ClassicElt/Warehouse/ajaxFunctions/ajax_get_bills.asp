<% Option Explicit %>
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_export_bills.inc" -->
<!--  #INCLUDE VIRTUAL="/IFF_MAIN/ASP/include/GOOFY_import_bills.inc" -->
<%
Dim elt_account_number,login_name,UserRight
Dim searchType,searchArray,i,xmlDoc,exportType,importType,tableStr

elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
login_name = Request.Cookies("CurrentUserInfo")("login_name")
UserRight = Request.Cookies("CurrentUserInfo")("user_right")

searchType = checkBlank(Request.QueryString("type"),"")
exportType = checkBlank(Request.QueryString("export"),"")
importType = checkBlank(Request.QueryString("import"),"")
tableStr = checkBlank(Request.QueryString("table"),"")

On Error Resume Next:
If exportType <> "" Then

    If exportType = "A" Then
        If searchType = "house" Then
            Set searchArray = get_HAWB_list(elt_account_number)
        Elseif searchType = "master" Then
            Set searchArray = get_MAWB_list(elt_account_number)
        Elseif searchType = "masteronly" Then
            Set searchArray = get_MAWB_only_list(elt_account_number)
        Elseif searchType = "none" Then
            Set searchArray = get_none_array(elt_account_number,exportType)
        Else
        End If
        
    Elseif exportType = "O" Then
        If searchType = "house" Then
            Set searchArray = get_HBOL_list(elt_account_number)
        Elseif searchType = "booking" Then
            Set searchArray = get_Booking_list(elt_account_number)
        Elseif searchType = "bookingonly" Then
            Set searchArray = get_Booking_Only_list(elt_account_number)
        Elseif searchType = "none" Then
            Set searchArray = get_none_array(elt_account_number,exportType)
        Else
        End If
    End If
    Call write_export_xml()
    
Elseif importType <> "" Then

    If importType = "A" Then
        If searchType = "house" Then
            Set searchArray = get_import_HAWB_list(elt_account_number)
        Elseif searchType = "none" Then
            Set searchArray = get_none_array(elt_account_number,importType)
        Else
        End If

    Elseif importType = "O" Then
        If searchType = "house" Then
            Set searchArray = get_import_HBOL_list(elt_account_number)
        Elseif searchType = "none" Then
            Set searchArray = get_none_array(elt_account_number,importType)
        Else
        End If
    Else
    End If
    Call write_import_xml()

End If

Sub write_export_xml()
    Response.Expires = 0  
    Response.AddHeader "Pragma","no-cache"  
    Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
    Response.ContentType = "text/xml"
    Response.CharSet = "utf-8"

    Response.Write "<?xml version=""1.0"" encoding=""utf-8""?>"
    Response.Write "<selectItems>"
    
    If Not IsNull(searchArray) And Not IsEmpty(searchArray) Then
        For i=0 To searchArray.count-1
        Response.Write "<item>"
        Response.Write "<itemValue>" & searchArray(i) & "</itemValue>"
        Response.Write "<itemLabel>" & searchArray(i) & "</itemLabel>"
        Response.Write "</item>"
        Next
    End If
    Response.Write "</selectItems>"


End Sub

Sub write_import_xml()
    Response.Expires = 0  
    Response.AddHeader "Pragma","no-cache"  
    Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
    Response.ContentType = "text/xml"
    Response.CharSet = "utf-8"
    
    Response.Write "<?xml version=""1.0"" encoding=""utf-8""?>"
    Response.Write "<selectItems>"
    
    If searchType <> "none" Then
        If Not IsNull(searchArray) And Not IsEmpty(searchArray) Then
            For i=0 To searchArray.count-1
            Response.Write "<item>"
            Response.Write "<itemValue>" & encodeXMLCode("hawb=" & searchArray(i)("hawb") & "&mawb=" & searchArray(i)("mawb") & "&sec=" & searchArray(i)("sec")) & "</itemValue>"
            Response.Write "<itemLabel>" & encodeXMLCode(searchArray(i)("key")) & "</itemLabel>"
            Response.Write "</item>"
            Next
        End If
        Response.Write "</selectItems>"
    Else
        If Not IsNull(searchArray) And Not IsEmpty(searchArray) Then
            For i=0 To searchArray.count-1
            Response.Write "<item>"
            Response.Write "<itemValue>" & encodeXMLCode("file=" & searchArray(i)) & "</itemValue>"
            Response.Write "<itemLabel>" & encodeXMLCode(searchArray(i)) & "</itemLabel>"
            Response.Write "</item>"
            Next
        End If
        Response.Write "</selectItems>"
    End If
End Sub

Function get_none_array(elt_num,ship_type)
    Dim none_array,SQL,rs
    Set rs = Server.CreateObject("ADODB.Recordset")
    Set none_array = Server.CreateObject("System.Collections.ArrayList")
    
    If tableStr = "PO" Then
        SQL = "SELECT DISTINCT file_name FROM pickup_order where " _
            & "elt_account_number=" & elt_num  & " AND eType='" & ship_type _
            & "' AND anonymous='Y' AND file_name IS NOT NULL AND file_name!='' ORDER BY file_name"
    Elseif tableStr = "DO" Then
        SQL = "SELECT DISTINCT file_name FROM delivery_order where " _
            & "elt_account_number=" & elt_num  & " AND iType='" & ship_type _
            & "' AND anonymous='Y' AND file_name IS NOT NULL AND file_name!='' ORDER BY file_name"
    Elseif tableStr = "CO" Then
        If exportType = "A" Then
            SQL = "SELECT DISTINCT file_name FROM certificate_origin_air where " _
                & "elt_account_number=" & elt_num  _
                & " AND anonymous='Y' AND file_name IS NOT NULL AND file_name!='' ORDER BY file_name"
        Else
            SQL = "SELECT DISTINCT file_name FROM certificate_origin_ocean where " _
                & "elt_account_number=" & elt_num  _
                & " AND anonymous='Y' AND file_name IS NOT NULL AND file_name!='' ORDER BY file_name"
        End If
    Else
    End If
    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
    
	Do While Not rs.eof And Not rs.bof
		none_array.Add rs("file_name").value
		rs.MoveNext
	Loop
	rs.Close
	Set get_none_array = none_array
End Function

%>

