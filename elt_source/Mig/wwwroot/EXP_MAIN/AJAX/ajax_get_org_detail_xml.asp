<!--  #INCLUDE FILE="../Include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="../Include/connection.asp" -->
<!--  #INCLUDE FILE="../Include/Header.inc" -->
<!--  #INCLUDE FILE="../Include/GOOFY_Util_fun.inc" -->
<!--  #INCLUDE FILE="../Include/GOOFY_data_manager.inc" -->
<%
	
	Dim orgNo
	
	Call GetParameters
	Call GetAllInfo

    eltConn.Close()
    Set eltConn = Nothing
    
	Sub GetParameters
	    orgNo = checkBlank(Request.QueryString("orgNo"),0)
	End Sub
	
	Sub GetAllInfo
	
	    Dim SQL,dataTable,dataObj
	    
	    SQL = "SELECT * FROM organization WHERE elt_account_number=" & elt_account_number _
	        & " AND org_account_number=" & orgNo
	    
	    Set dataObj = new DataManager
        dataObj.SetDataList(SQL)
        Set dataTable = dataObj.GetRowTable(0)
        
		'// When country code is not available search by country name
		If checkBlank(dataTable("b_country_code"),"") = "" And checkBlank(dataTable("business_country"),"") <> "" Then
			Dim vCountryCode
			vCountryCode = GetSQLResult("SELECT country_code FROM country_code WHERE country_name='" & Trim(dataTable("business_country")) & "' AND elt_account_number=" & elt_account_number, Null)
			dataTable("b_country_code") = vCountryCode
		End If

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
%>