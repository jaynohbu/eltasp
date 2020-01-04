<!--  #INCLUDE FILE="../include/transaction.txt" -->
<%
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE VIRTUAL="/ASP/include/connection.asp" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_util_fun.inc" -->
<!--  #INCLUDE VIRTUAL="/ASP/include/GOOFY_data_manager.inc" -->
<%
	
	Dim mode,filter,qStr,topNum,cursorStr,error_code,getType,vCostItemNo
	
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
	
	mode = checkBlank(Request.QueryString("mode"),"")
	vCostItemNo = checkBlank(Request.QueryString("cid"),"")
	
    error_code = 0
 
    If mode = "list" Then
        filter = checkBlank(Request.QueryString("filter"),"")
        qStr = checkBlank(Request.QueryString("qStr"),"")
        topNum = CInt(checkBlank(Request.QueryString("limit"),0))
        cursorStr = checkBlank(Request.QueryString("cursor"),"")
        
        If filter = "ExpenseCost" Then
            Call get_expense_cost_list
        End If
        If filter = "ItemCost" Then
            Call get_cost_item_list
        End If
        If filter = "ItemChargeNameDesc" Then
            Call get_charge_item_name_desc_list
        End If
        If filter = "ItemCostNameDesc" Then
            Call get_cost_item_name_desc_list
        End If
    Elseif mode = "CostItemInfo" Then
        Call GetCostItemInfo
    Elseif mode = "ChargeItemInfo" Then
        Call GetChargeItemInfo
    Elseif mode = "get" Then
        getType = checkBlank(Request.QueryString("type"),"")
        
        If getType = "BankInfo" Then
            Call get_gl_info(checkBlank(Request.QueryString("gl"),""))
        End If
    End If
 
    Sub GetCostItemInfo
	
	    Dim SQL,dataTable,dataObj
	    
	    SQL = "SELECT *,item_name+'---'+item_desc AS item_label " _
	        & "FROM item_cost WHERE elt_account_number=" & elt_account_number & " AND item_no=" & vCostItemNo
	    
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
	
	
	Sub GetChargeItemInfo
	
	    Dim SQL,dataTable,dataObj
	    
	    SQL = "SELECT *,item_name+'---'+item_desc AS item_label " _
	        & "FROM item_charge WHERE elt_account_number=" & elt_account_number & " AND item_no=" & vCostItemNo
	    
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
	
	Sub get_cost_item_name_desc_list()
        Dim SQL,rs,vItemNo,cusorFilter
        
        vItemNo = 0
        SQL = "SELECT * FROM item_cost WHERE elt_account_number=" & elt_account_number & " ORDER BY item_name"

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
        
        Dim tmpValStr
        Dim tmpLabelStr
        
        If cursorStr <> "" Then
            cusorFilter = "on"
        Else
            cusorFilter = "off"
        End If
        
        Do While Not rs.EOF and NOT rs.bof and vItemNo<topNum
            tmpValStr = rs("item_no").value
            tmpLabelStr = encodeXMLCode(RemoveQuotations(rs("item_name").value & "---" & rs("item_desc").value))
            
            If InStr(UCase(tmpLabelStr),UCase(qStr))=1 Then
                If cusorFilter = "on" And CStr(tmpLabelStr) = CStr(cursorStr) Then
                    cusorFilter = "off"
                End If
                If cusorFilter = "off" Then
                    Response.Write "<item>"
                    Response.Write "<value>" & tmpValStr & "</value>"
                    Response.Write "<label>" & tmpLabelStr & "</label>"
                    Response.Write "</item>"
                    vItemNo = vItemNo + 1
                End If
            End If
            rs.MoveNext
	    Loop
        Response.Write "</FormDocument>"
        rs.Close()

    End Sub
    
    Sub get_charge_item_name_desc_list()
        Dim SQL,rs,vItemNo,cusorFilter
        
        vItemNo = 0
        SQL = "SELECT * FROM item_charge WHERE elt_account_number=" & elt_account_number & " ORDER BY item_name"

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
        
        Dim tmpValStr
        Dim tmpLabelStr
        
        If cursorStr <> "" Then
            cusorFilter = "on"
        Else
            cusorFilter = "off"
        End If
        
        Do While Not rs.EOF and NOT rs.bof and vItemNo<topNum
            tmpValStr = rs("item_no").value
            tmpLabelStr = encodeXMLCode(RemoveQuotations(rs("item_name").value & "---" & rs("item_desc").value))
            
            If InStr(UCase(tmpLabelStr),UCase(qStr))=1 Then
                If cusorFilter = "on" And CStr(tmpLabelStr) = CStr(cursorStr) Then
                    cusorFilter = "off"
                End If
                If cusorFilter = "off" Then
                    Response.Write "<item>"
                    Response.Write "<value>" & tmpValStr & "</value>"
                    Response.Write "<label>" & tmpLabelStr & "</label>"
                    Response.Write "</item>"
                    vItemNo = vItemNo + 1
                End If
            End If
            rs.MoveNext
	    Loop
        Response.Write "</FormDocument>"
        rs.Close()
    End Sub
    
    Sub get_gl_info(vGLAccount)
        Dim SQL,rs,first_date,last_date
        
        last_date = get_fiscal_year_of_last_date( year(date) )
        first_date = get_fiscal_year_of_first_date( last_date )
        
        SQL= "select (select control_no from gl where elt_account_number=" & elt_account_number _
            & " and gl_account_number=" & vGLAccount & ") as check_no," _
            & "sum(credit_amount+debit_amount+ISNULL(debit_memo,0)+ISNULL(credit_memo,0)) " _
            & "as balance from all_accounts_journal where elt_account_number=" _
            &  elt_account_number & " and gl_account_number=" & vGLAccount _
            & " and tran_date >='" & first_date _
            & "' and tran_date < DATEADD(day, 1,'"& last_date &"') "
            
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
        
        If Not rs.EOF And Not rs.BOF Then
            Response.Write "<GLAccount>"
            Response.Write "<Balance>" & rs("balance").value & "</Balance>"
            Response.Write "<CheckNum>" & rs("check_no").value & "</CheckNum>"
            Response.Write "</GLAccount>"
        End If
        
        Response.Write "</FormDocument>"
        rs.Close()
    End Sub 

    
    
    Sub get_cost_item_list()
        Dim SQL,rs,vItemNo,cusorFilter
        
        vItemNo = 0
        SQL = "SELECT * FROM item_cost WHERE elt_account_number=" & elt_account_number & " ORDER BY item_desc"
        
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
        
        Dim tmpValStr
        Dim tmpLabelStr
        
        If cursorStr <> "" Then
            cusorFilter = "on"
        Else
            cusorFilter = "off"
        End If
        
        Do While Not rs.EOF and NOT rs.bof and vItemNo<topNum
            tmpValStr = rs("item_no").value & "-" & rs("unit_price").Value
            tmpLabelStr = encodeXMLCode(RemoveQuotations(rs("item_desc").value))
            
            If InStr(UCase(tmpLabelStr),UCase(qStr))=1 Then
                If cusorFilter = "on" And CStr(tmpLabelStr) = CStr(cursorStr) Then
                    cusorFilter = "off"
                End If
                If cusorFilter = "off" Then
                    Response.Write "<item>"
                    Response.Write "<value>" & tmpValStr & "</value>"
                    Response.Write "<label>" & tmpLabelStr & "</label>"
                    Response.Write "</item>"
                    vItemNo = vItemNo + 1
                End If
            End If
            rs.MoveNext
	    Loop
        Response.Write "</FormDocument>"
        rs.Close()

    End Sub
    
    
    Sub get_expense_cost_list()
        Dim SQL,rs,vItemNo,cusorFilter
        
        vItemNo = 0
        SQL = "(select a.item_name,a.item_no,a.item_desc,a.account_expense,b.gl_account_number,b.gl_account_desc,1 as type " _
            & "from item_cost a left outer join gl b on (a.elt_account_number=b.elt_account_number and a.account_expense=b.gl_account_number AND ISNULL(a.account_expense,0)<>0) " _
            & "where a.elt_account_number=" & elt_account_number & " and b.gl_master_type='EXPENSE') "
            '& "union " _
            '& "(select cast(gl_account_number as nvarchar) as item_name,0 as item_no, gl_account_desc as item_desc,gl_account_number as account_expense," _
            '& "gl_account_number, gl_account_desc,0 as type from gl where elt_account_number=" & elt_account_number & " and gl_master_type='EXPENSE') " _
            
        SQL = SQL & " order by account_expense,type,item_desc"

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
        
        Dim tmpValStr
        Dim tmpLabelStr
        
        If cursorStr <> "" Then
            cusorFilter = "on"
        Else
            cusorFilter = "off"
        End If
        
        Do While Not rs.EOF and NOT rs.bof and vItemNo<topNum
            tmpValStr = rs("item_no").value & "-" & rs("account_expense").Value
            tmpLabelStr = encodeXMLCode(RemoveQuotations(rs("item_name").value & "---" & rs("item_desc").Value))
            
            If InStr(UCase(tmpLabelStr),UCase(qStr))=1 Then
                If cusorFilter = "on" And CStr(tmpLabelStr) = CStr(cursorStr) Then
                    cusorFilter = "off"
                End If
                If cusorFilter = "off" Then
                    Response.Write "<item>"
                    Response.Write "<value>" & tmpValStr & "</value>"
                    Response.Write "<label>" & tmpLabelStr & "</label>"
                    Response.Write "</item>"
                    vItemNo = vItemNo + 1
                End If
            End If
            rs.MoveNext
	    Loop
        Response.Write "</FormDocument>"
        rs.Close()

    End Sub
    
    Function get_fiscal_year_of_first_date( vFiscalTo )

        DIM vFiscalFrom
        vFiscalFrom = DateAdd("m",-11,vFiscalTo)
        vFiscalFrom = cStr(month(vFiscalFrom)) & "/01/" & cStr(year(vFiscalFrom))

        get_fiscal_year_of_first_date = vFiscalFrom
    End Function

    Function get_fiscal_year_of_last_date( vFiscalYear )

        Dim tmpYear,tmpMonth,vCalcYear,vFiscalFrom,vFiscalTo,vfiscalEndMonth,rs,SQL
	    Set rs = Server.CreateObject("ADODB.Recordset")
    	
        SQL= "select * from user_profile where elt_account_number = " & elt_account_number
        rs.CursorLocation = adUseClient
        rs.Open SQL, eltConn, adOpenForwardOnly, , adCmdText
        Set rs.activeConnection = Nothing
        
        If Not rs.EOF Then
	        vfiscalEndMonth=rs("fiscalEndMonth")
        end if
        rs.close

        if isnull(vFiscalEndMonth) or trim(vFiscalEndMonth) = "" then
	        vFiscalEndMonth = "12"
        end if

        tmpMonth = month(date)

        if vFiscalYear = "" or isnull( vFiscalYear ) then
	        if ( cInt(tmpMonth) = cInt(vfiscalEndMonth) ) then
		        if 	cInt(vfiscalEndMonth) = 12 then
 		          vFiscalYear = year(date)
		          vCalcYear = cInt(vFiscalYear)  
	  	        else
		          vCalcYear = year(date)	
 		          vFiscalYear = year(date) - 1
		        end if		
	        else
		        if 	cInt(vfiscalEndMonth) = 12 then
		          if cInt(tmpMonth	< 4) then
			          vFiscalYear = year(date) - 1
			          vCalcYear = cInt(vFiscalYear)
		          else
			          vFiscalYear = year(date)
			          vCalcYear = cInt(vFiscalYear)
		          end if			    
	  	        else
 		          vFiscalYear = year(date) -1 
		          vCalcYear =   year(date)
		        end if		
	        end if
        else
	        vCalcYear = cInt(vFiscalYear)  
        end if

        vFiscalTo = vfiscalEndMonth & "/" & "01" & "/" & cStr(vCalcYear)
        vFiscalTo = DateAdd("m",1,vFiscalTo)
        vFiscalTo = DateAdd("d",-1,vFiscalTo)

        get_fiscal_year_of_last_date = vFiscalTo

    End Function
    
 %>
 