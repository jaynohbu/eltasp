<%
'///////////////////////////////////////////////////////////////////////////////////////////////////////
'//  
'//  Created By Joon Park On Dec-13-2006
'//
'//  Collections of useful functions..
'//
'//
'//  Hope this will help U guys... Thnx to Joon  ^_____________________^
'//
'///////////////////////////////////////////////////////////////////////////////////////////////////////

'// Get Form Object and Write their names //////////////////////////////////////////////////////////////
Sub GetFormObjects(req,res)
    res.clear()
    res.Write(URLDecodePlus(req.Form.Item))
    res.End()
End Sub 
'///////////////////////////////////////////////////////////////////////////////////////////////////////

'// URL Decoding: Translate query string into normal string ////////////////////////////////////////////
Function URLDecodePlus(txt)

Dim txt_len
Dim ch
Dim digits
Dim result

    result = ""
    txt_len = Len(txt)
    i = 1
    Do While i <= txt_len
        '-- Examine the next character.
        ch = Mid(txt, i, 1)
        If ch = "+" Then
            '-- Convert to space character.
            result = result & " "
        ElseIf ch <> "%" Then
            '-- Normal character.
            result = result & ch
        ElseIf i > txt_len - 2 Then
            '-- No room for two following digits.
            result = result & ch
        Else
            '-- Get the next two hex digits.
            digits = Mid(txt, i + 1, 2)
            result = result & Chr(CInt("&H" & digits))
            i = i + 2
        End If
        i = i + 1
    Loop
    
    result = Replace(result,"&",chr(13))
    
    URLDecodePlus = result
End Function
'/////////////////////////////////////////////////////////////////////////////////////////////////////////

'// Checks blank if null or "" then return default value /////////////////////////////////////////////////
Function checkBlank(arg1,arg2)
    Dim result
    If IsNull(arg1) Then 
        result = arg2
    Else
		If Trim(arg1)="" Then
			result = arg2
		Else
			result = Trim(arg1)
		End If
    End If    
    checkBlank = result
    
End Function

'// check File length ///////////////////////////////////////////////////////////////////////////////////
Function FileLen(byVal pathname)
	Dim objFSO, objFile
	On Error Resume Next
	Set objFSO	= Server.CreateObject("Scripting.FileSystemObject")
	Set objFile	= objFSO.GetFile(pathname)
	If Err Then
		FileLen = Null
	Else
		FileLen = CLng( objFile.Size )
	End If
	Set objFile	= Nothing
	Set objFSO	= Nothing
	On Error GoTo 0
End Function

'// Make XML code
'// 
function encodeXMLCode( val )
DIM retVal
retVal = ""
if isnull(val) then
else
	retVal = val
	retVal = Replace(retVal,"&","&amp;") 
	retVal = Replace(retVal,"<","&lt;") 
	retVal = Replace(retVal,">","&gt;") 
	retVal = Replace(retVal,"(","&#40;")
	retVal = Replace(retVal,")","&#41;")
end if
encodeXMLCode = retVal
end function

'// Make XML code
'// 
Function MakeXMLString(dataTable,keyArray)
    Dim resVal,i,dataKeys,dataValues

    resVal = ""
    
    If Not IsNull(dataTable) And Not IsEmpty(dataTable) Then
        For i=0 To dataTable.Count-1

            resVal = resVal & "<" & Replace(encodeXMLCode(keyArray(i)),"#","NO") & ">" _
                & encodeXMLCode(dataTable(keyArray(i))) & "</" _
                & Replace(encodeXMLCode(keyArray(i)),"#","NO") & ">" & chr(13)
        
        Next
    End If

    MakeXMLString = resVal
End Function


'// formatting date 
'// Usage: FormatDatePlus(now(),"yyyy-mm-dd") 

Function FormatDatePlus(txt,sformat)
    on Error Resume Next:
    Dim fmt,rsDate
    set fmt = CreateObject("MSSTDFMT.StdDataFormat")
    fmt.Format = sformat
    set rsDate = CreateObject("ADODB.Recordset")
    
    rsDate.Fields.Append "fld", adVariant 
    
    rsDate.open
    rsDate.addNew
    set rsDate("fld").DataFormat = fmt 
    
    rsDate("fld").value = txt 
    FormatDatePlus = rsDate("fld").value 
    
    rsDate.close
    Set rsDate = Nothing
    Set fmt = Nothing
End Function

'// originStr: string containing badStr pieces
'// possiblities of similar patterens are ommited in this case
'// Asumption is made that the badStr is always part of originStr in exact pattern
'// This function is made to remove company name from address info

Function SmartReplace(originStr,badStr)
    Dim txtArray,i,j,resStr
    resStr = ""
    On Error Resume Next:

    originStr = Replace(originStr,chr(10),"")
    
    txtArray = Split(originStr,chr(13))
    For i=0 To UBound(txtArray)
        Dim txtArrayChild
        txtArrayChild = Split(txtArray(i))
        For j=0 To UBound(txtArrayChild)
            
            If InStr(badStr,Trim(txtArrayChild(j))) > 0 Or Trim(txtArrayChild(j)) = Trim(badStr) Then
                badStr = Replace(badStr,txtArrayChild(j),"")
            Else
                resStr = resStr & " " & txtArrayChild(j)
            End If
        Next
        If checkBlank(resStr,"") <> "" Then
            resStr = resStr & chr(13)
        End If
    Next

    SmartReplace = resStr
End Function

Function FormatAmount (argStrVal)
    Dim returnVal
	If Not IsNull(argStrVal) And Trim(argStrVal) <> "" Then
		argStrVal = Trim(argStrVal)
		If isnumeric(argStrVal) And Not isempty(argStrVal) Then
			If argStrVal <> "0" Then
				returnVal = FormatNumber(argStrVal,2)
			End If
		Else
			returnVal = argStrVal
		End If
	Else
		returnVal = ""
	End If
	FormatAmount = returnVal
End Function

Function FormatNumberPlus(argStrVal,decim)
    Dim returnVal
    returnVal = 0
	If Not IsNull(argStrVal) And Trim(argStrVal) <> "" Then
		argStrVal = Trim(argStrVal)
		If isnumeric(argStrVal) And Not isempty(argStrVal) Then
		    returnVal = FormatNumber(argStrVal,decim,,,0)
		End If
    End If
	FormatNumberPlus = returnVal
End Function

%>

<%

'// Get Additional Infomaation /////////////////////////////////////////////////////////////

Function GetUserFLName(userId)
    Dim resultValue,sqlTxt,rsObj
    resultValue = ""
    sqlTxt = "SELECT user_lname,user_fname FROM users WHERE userid=" & userId _
        & " AND elt_account_number=" & elt_account_number
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    rsObj.Open sqlTxt, eltConn, , , adCmdText

    If Not rsObj.EOF And Not rsObj.BOF Then
        resultValue = rsObj("user_fname").value & " " & rsObj("user_lname").value
    End If

    GetUserFLName = resultValue
End Function

Function GetAgentName(eltNum)
    Dim resultValue,sqlTxt,rsObj
    resultValue = ""
    sqlTxt = "SELECT dba_name FROM agent WHERE elt_account_number=" _
        & eltNum
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    rsObj.Open sqlTxt, eltConn, , , adCmdText

    If Not rsObj.EOF And Not rsObj.BOF Then
        resultValue = rsObj("dba_name").value
    End If

    GetAgentName = resultValue
End Function

Function GetAgentAddress(eltNum)
    Dim tmpShipper_info,SQL,rs
    Set rs = Server.CreateObject("ADODB.Recordset")
    
    SQL= "select isnull(dba_name,'') as dba_name,isnull(business_address,'') as business_address" _
        & ",isnull(business_city,'') as business_city,isnull(business_state,'') as business_state" _
        & ",isnull(business_zip,'') as business_zip,isnull(business_country,'') as business_country" _
        & ",isnull(business_phone,'') as business_phone,isnull(business_fax,'') as business_fax " _
        & "from agent where elt_account_number = " & eltNum

    Set rs = eltConn.execute(SQL)
    if Not rs.EOF Then
	    tmpShipper_info = rs("business_address") & chr(13) & rs("business_city") _
	        & "," & rs("business_state") & " " & rs("business_zip") _
	        & "," & rs("business_country") & chr(13)
	    
	    If Not IsNull(rs("business_phone")) And Trim(rs("business_phone")) <> "" Then
	        tmpShipper_info = tmpShipper_info & "Tel:" & rs("business_phone") & " "
	    End If
	    If Not IsNull(rs("business_fax")) And Trim(rs("business_fax")) <> "" Then
	        tmpShipper_info = tmpShipper_info & "Fax:" & rs("business_fax") & " "
	    End If
	    
    end if
    rs.Close
    GetAgentAddress = tmpShipper_info
End Function

Function GetAgentCity(eltNum)
    Dim resultValue,sqlTxt,rsObj
    resultValue = ""
    sqlTxt = "SELECT business_city FROM agent WHERE elt_account_number=" _
        & eltNum
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    rsObj.Open sqlTxt, eltConn, , , adCmdText

    If Not rsObj.EOF And Not rsObj.BOF Then
        resultValue = rsObj("business_city").value
    End If

    GetAgentCity = resultValue
End Function

Function GetBusinessInfo(arg)
    Dim result,sqlTxt,rsObj
    result = ""
    sqlTxt = "SELECT dba_name,business_address,business_city," _
        & "business_state,business_zip,business_country FROM " _
        & "organization WHERE org_account_number=" & arg _
        & " AND elt_account_number=" & elt_account_number
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    rsObj.Open sqlTxt, eltConn, , , adCmdText
    
    If Not rsObj.EOF And Not rsObj.BOF Then
    
        result = rsObj("dba_name").value & chr(13) _
            & rsObj("business_address").value & chr(13) _
            & checkBlank(rsObj("business_city").value,"")
        
        If checkBlank(rsObj("business_state").value,"") <> "" Then
            result = result & ","
        End If
        
        result = result & checkBlank(rsObj("business_state").value,"")
        
        If checkBlank(rsObj("business_zip").value,"") <> "" Then
            result = result & " "
        End If            
        
        result = result & checkBlank(rsObj("business_zip").value,"")
        
        If checkBlank(rsObj("business_country").value,"") <> "" Then
            result = result & chr(13)
        End If 
        
        result = result & checkBlank(rsObj("business_country").value,"")        
    End If
    GetBusinessInfo = result
End Function

Function GetBusinessName(arg)
    Dim result,sqlTxt,rsObj
    result = ""
    sqlTxt = "SELECT dba_name from organization where org_account_number=" & arg _
        & " AND elt_account_number=" & elt_account_number
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    rsObj.Open sqlTxt, eltConn, , , adCmdText
    
    If Not rsObj.EOF And Not rsObj.BOF Then
        result = rsObj("dba_name").value  
    End If
    GetBusinessName = result
End Function

Function GetBusinessTelFax(arg)
    Dim result,sqlTxt,rsObj
    result = ""
    sqlTxt = "SELECT business_phone,business_fax FROM " _
        & "organization WHERE org_account_number=" & arg _
        & " AND elt_account_number=" & elt_account_number
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    rsObj.Open sqlTxt, eltConn, , , adCmdText
    
    If Not rsObj.EOF And Not rsObj.BOF Then
        If checkBlank(rsObj("business_phone").value,"") <> "" Then
            result = "Tel: " & checkBlank(rsObj("business_phone").value,"")
        End If
        
        If checkBlank(rsObj("business_fax").value,"") <> "" Then
            result = result & "  " & "Fax: " _
                & checkBlank(rsObj("business_fax").value,"")
        End If
    End If
    GetBusinessTelFax = result
End Function

Function GetFreightName(firmcode,eltNum)
    Dim result,sqlTxt,rsObj
    result = ""
    sqlTxt = "SELECT location FROM freight_location WHERE elt_account_number=" & eltNum _
        & " AND firm_code='" & firmcode & "'"
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    rsObj.Open sqlTxt, eltConn, , , adCmdText
    If Not rsObj.EOF And Not rsObj.BOF Then
        result = rsObj("location").value
    End If
    GetFreightName = result
End Function


Function RemoveQuotations(arg)
    Dim temp
    If IsNull(arg) Or Trim(arg) = "" Then
        temp = ""
    Else
        temp = Replace(arg,chr(34)," ")
        temp = Replace(temp,chr(39),chr(60))
    End If
    RemoveQuotations = temp
End Function

Function GetPrefixFileNumber(typeStr,eltNum)
    Dim result,sqlTxt,rsObj
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    result = ""
    sqlTxt= "select prefix,next_no from user_prefix where elt_account_number = " & eltNum _
        & " and type='"& typeStr & "' order by prefix"
	rsObj.Open sqlTxt, eltConn, , , adCmdText
	
	If Not rsObj.EOF And Not rsObj.BOF Then
	    result = rs("prefix").value & "-" & rs("next_no").value
	End If
	GetPrefixFileNumber = result
End Function

Function GetPortCity(vPortCode)

    Dim result,sqlTxt,rsObj
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    result = ""
    sqlTxt= "select port_city, port_desc from port where elt_account_number=" & elt_account_number _
        & " and port_code like '" & vPortCode & "'"
	rsObj.Open sqlTxt, eltConn, , , adCmdText
	
	If Not rsObj.EOF And Not rsObj.BOF Then
	    result = rs("port_city").value
	End If
	GetPortCity = result


End Function 
    
%>