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
    res.Write(GetRequestForm(req))
End Sub 
'///////////////////////////////////////////////////////////////////////////////////////////////////////

Function GetRequestForm(Req)
    Dim i, result
    
    result = "" 
    For i=1 To Req.Form.Count
        result =  result & Req.Form.Key(i) & " : " & Req.Form(i).Item & "<br />"
    Next
    GetRequestForm = result
End Function


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
    
    result = Replace(result,"&","<br/>")
    
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
        retVal = Server.HTMLEncode(val)
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
    
    rsDate.close()
    Set rsDate = Nothing
    Set fmt = Nothing
End Function

'// originStr: string containing badStr pieces
'// possiblities of similar patterens are ommited in this case
'// Asumption is made that the badStr is always part of originStr in exact pattern
'// This function is made to remove company name from address info

Function SmartReplace(originStr,badStr)
    on Error Resume Next:
    Dim txtArray,i,j,resStr
    resStr = ""
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
    returnVal = FormatNumber(0,decim,,,0)
	If Not IsNull(argStrVal) And Trim(argStrVal) <> "" Then
		argStrVal = Trim(argStrVal)
		If isnumeric(argStrVal) And Not isempty(argStrVal) Then
		    returnVal = FormatNumber(argStrVal,decim,,,0)
		End If
    End If
	FormatNumberPlus = returnVal
End Function

Function IsDataExist(sqlTxt)
    Dim resultValue,rsObj
    resultValue = False
    
    Set rsObj = Server.CreateObject("ADODB.Recordset")

    rsObj.Open sqlTxt, eltConn, , , adCmdText
    If Not rsObj.EOF And Not rsObj.BOF Then
        resultValue = True
    End If
    rsObj.Close()
    isDataExist = resultValue
End Function


Function MakeJavaString(arg)
    Dim resVal
    
    resVal = ""
    If IsNull(arg) Or IsEmpty(arg) Or Trim(arg)="" Then
    Else
        resVal = Replace(Replace(arg,chr(10),""),chr(13),"\n")
        resVal = Replace(resVal,chr(34),"\"&chr(34))
    End If
    
    MakeJavaString = resVal

End Function

Function ReplaceAllButNumbers(arg)
    Dim resVal,arg_index,tmpVal
    
    resVal = ""
    
    If IsNull(arg) Or IsEmpty(arg) Or Trim(arg)="" Then
    Else
        For arg_index = 0 To Len(arg)
            tmpVal = Mid(arg, arg_index+1, 1)
            If IsNumeric(tmpVal) Then
                resVal = resVal & tmpVal
            End If
        Next
    End If
    
    ReplaceAllButNumbers = resVal
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
    rsObj.Close()
    GetUserFLName = resultValue
End Function

Function GetAgentName(eltNum)
    Dim resultValue,sqlTxt,rsObj
    resultValue = ""
    sqlTxt = "SELECT dba_name FROM agent WHERE elt_account_number=" & eltNum

    Set rsObj = Server.CreateObject("ADODB.Recordset")
    rsObj.Open sqlTxt, eltConn, , , adCmdText

    If Not rsObj.EOF And Not rsObj.BOF Then
        resultValue = rsObj("dba_name").value
    End If
    rsObj.Close()
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
    rs.Close()
    GetAgentAddress = tmpShipper_info
End Function

Function GetAgentCity(eltNum)
    Dim resultValue,sqlTxt,rsObj
    resultValue = ""
    sqlTxt = "SELECT business_city FROM agent WHERE elt_account_number=" & eltNum

    Set rsObj = Server.CreateObject("ADODB.Recordset")
    rsObj.Open sqlTxt, eltConn, , , adCmdText

    If Not rsObj.EOF And Not rsObj.BOF Then
        resultValue = rsObj("business_city").value
    End If
    rsObj.Close()
    GetAgentCity = resultValue
End Function

Function GetBusinessInfo(arg)
    Dim result,sqlTxt,rsObj
    result = ""
    
    If arg <> "" Then  
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
                result = result & "," & checkBlank(rsObj("business_country").value,"")
            End If 
                 
        End If
        rsObj.Close()
    End If
    GetBusinessInfo = result
End Function

Function GetBusinessAddress(arg)
    Dim result,sqlTxt,rsObj
    result = ""
    
    If arg <> "" Then  
        sqlTxt = "SELECT dba_name,business_address,business_city," _
            & "business_state,business_zip,business_country FROM " _
            & "organization WHERE org_account_number=" & arg _
            & " AND elt_account_number=" & elt_account_number

        Set rsObj = Server.CreateObject("ADODB.Recordset")

        rsObj.Open sqlTxt, eltConn, , , adCmdText
        
        If Not rsObj.EOF And Not rsObj.BOF Then
        
            result = rsObj("business_address").value & chr(13) _
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
                result = result & "," & checkBlank(rsObj("business_country").value,"")
            End If 
                 
        End If
        rsObj.Close()
    End If
    GetBusinessAddress = result
End Function

Function GetBusinessName(arg)
    Dim result,sqlTxt,rsObj
    result = ""
    
    If arg <> "" Then  
        sqlTxt = "SELECT dba_name from organization where org_account_number=" & arg _
            & " AND elt_account_number=" & elt_account_number

        Set rsObj = Server.CreateObject("ADODB.Recordset")

        rsObj.Open sqlTxt, eltConn, , , adCmdText
        
        If Not rsObj.EOF And Not rsObj.BOF Then
            result = rsObj("dba_name").value
        End If
        rsObj.Close()
    End If
    GetBusinessName = result
End Function

Function GetBusinessTelFax(arg)
    Dim result,sqlTxt,rsObj
    result = ""
    
    If arg <> "" Then  
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
        rsObj.Close()
    End If
    GetBusinessTelFax = result
End Function


Function GetOrgNameAddress(org)
    Dim tempInfo,SQL,rs
    
    Set rs = Server.CreateObject("ADODB.Recordset")
    
    SQL = "select isnull(dba_name,'') as dba_name,isnull(business_address,'') as business_address" _
        & ",isnull(business_city,'') as business_city,isnull(business_state,'') as business_state" _
        & ",isnull(business_zip,'') as business_zip,isnull(business_country,'') as business_country" _
        & ",isnull(business_phone,'') as business_phone,isnull(business_fax,'') as business_fax" _
        & ",is_shipper,org_account_number,isnull(' - ' + class_code,'') as class_code" _
        & ",isnull(char(13) + CAST(business_address2 AS NVARCHAR(1024)),'') as business_address2" _
        & " FROM organization where elt_account_number=" & elt_account_number _
		& " AND org_account_number=" & org
    
    eltConn.CursorLocation = adUseClient
	rs.CursorLocation = adUseClient	
	rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
    Set rs.ActiveConnection = Nothing

    If Not rs.EOF And Not rs.bof Then
		
		If rs("business_State").value = "" Then
			tempInfo =  rs("DBA_NAME").value & chr(10) & rs("business_address").value _
			    & rs("business_address2").value & chr(10) & rs("business_city").value _
			    & " " & rs("business_Zip").value _
				& "," & rs("business_Country").value & chr(10) 
		Else
            tempInfo = rs("DBA_NAME").value _
				& chr(10) & rs("business_address").value & rs("business_address2").value _
				& chr(10) & rs("business_city").value _
				& "," & rs("business_State").value & " " & rs("business_Zip").value _
				& "," & rs("business_Country").value & chr(10) 
		End If
		
		If Not IsNull(rs("business_phone").value) And Trim(rs("business_phone").value) <> "" Then
	        tempInfo = tempInfo & "Tel:" & rs("business_phone").value & " "
	    End If
	    
	    If Not IsNull(rs("business_fax").value) And Trim(rs("business_fax").value) <> "" Then
	        tempInfo = tempInfo & "Fax:" & rs("business_fax").value & " "
	    End If
		
	End If
    
    rs.Close
	Set rs = Nothing
    
    GetOrgNameAddress = RemoveQuotations(tempInfo)
End Function

Function GetFreightName(firmcode,eltNum)
    Dim result,sqlTxt,rsObj
    result = ""
    If firmcode <> "" Then  
        sqlTxt = "SELECT location FROM freight_location WHERE elt_account_number=" & eltNum _
            & " AND firm_code=N'" & firmcode & "'"

        Set rsObj = Server.CreateObject("ADODB.Recordset")
        rsObj.Open sqlTxt, eltConn, , , adCmdText
        If Not rsObj.EOF And Not rsObj.BOF Then
            result = rsObj("location").value
        End If
        rsObj.Close()
    End If
    GetFreightName = result
End Function


Function RemoveQuotations(arg)
    Dim temp
    If IsNull(arg) Or Trim(arg) = "" Then
        temp = ""
    Else
        temp = Replace(arg,chr(34)," ")
        temp = Replace(temp,chr(147)," ")
        temp = Replace(temp,chr(148)," ")
        temp = Replace(temp,chr(39)," ")
        temp = Replace(temp,chr(145)," ")
        temp = Replace(temp,chr(146)," ")
        temp = Replace(temp,chr(180)," ")
    End If
    RemoveQuotations = temp
End Function

Function GetPrefixFileNumber(typeStr,eltNum,prefix)
    Dim result,sqlTxt,rsObj
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    result = ""

    If checkBlank(prefix,"") <> "" Then
        sqlTxt= "select prefix,next_no from user_prefix where elt_account_number = " & eltNum _
            & " and type=N'"& typeStr & "' and prefix=N'" & prefix & "'"
    Else
        sqlTxt= "select prefix,next_no from user_prefix where elt_account_number = " & eltNum _
            & " and type=N'"& typeStr & "' order by seq_num"
    End If
    

	rsObj.Open sqlTxt, eltConn, , , adCmdText
	
	If Not rsObj.EOF And Not rsObj.BOF Then
	    result = rsObj("prefix").value & "-" & rsObj("next_no").value
	End If
	rsObj.Close()
	GetPrefixFileNumber = result
End Function


Sub SetNextPrefixFileNumber(typeStr,eltNum,prefix)
    Dim result,sqlTxt,rsObj
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    
    If checkBlank(prefix,"") <> "" Then
        sqlTxt= "select * from user_prefix where elt_account_number = " & eltNum _
            & " and type=N'"& typeStr & "' and prefix=N'" & prefix & "'"
    Else
        sqlTxt= "select * from user_prefix where elt_account_number = " & eltNum _
            & " and type=N'"& typeStr & "'"
    End If
    

	rsObj.Open sqlTxt,eltConn,adOpenDynamic,adLockPessimistic,adCmdText
	
	If Not rsObj.EOF And Not rsObj.BOF Then
	    rsObj("next_no") = FormatNumberPlus(rsObj("next_no").value,0) + 1
	    rsObj.update
	End If
	rsObj.Close()
End Sub


Function GetPortCity(vPortCode)

    Dim result,sqlTxt,rsObj
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    result = ""
    sqlTxt= "select isnull(port_desc,port_city) as port_name from port where elt_account_number=" _
    & elt_account_number & " and port_code like N'" & vPortCode & "'"
    
    On Error Resume Next:
        
	rsObj.Open sqlTxt, eltConn, , , adCmdText
	If Not rsObj.EOF And Not rsObj.BOF Then
	    result = rsObj("port_name").value
	End If
	GetPortCity = result

    rsObj.Close()
End Function 
    
    
Function GetPortInfo(vPortCode,colName)

    Dim result,sqlTxt,rsObj
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    result = ""
    sqlTxt= "select " & colName & " from port where elt_account_number=" & elt_account_number _
        & " and port_code like N'" & vPortCode & "'"
    
	rsObj.Open sqlTxt, eltConn, , , adCmdText
	If Not rsObj.EOF And Not rsObj.BOF Then
	    result = rsObj(colName).value
	End If
	GetPortInfo = result

    rsObj.Close()
End Function 
    
    
Function GetAllPrefixes(jobType)
        
    Dim SQL,rs,aFilePrefix,tempTable
    
    Set aFilePrefix = Server.CreateObject("System.Collections.ArrayList")
    SQL = "SELECT prefix,next_no FROM user_prefix WHERE elt_account_number=" & elt_account_number _
        & " AND type = N'" & jobType & "' order by seq_num"

    
    Set rs = Server.CreateObject("ADODB.Recordset")
    rs.CursorLocation = adUseClient	
    rs.Open SQL,eltConn,adOpenForwardOnly,adLockReadOnly,adCmdText
    Set rs.ActiveConnection = Nothing
    
    Do While Not rs.EOF and NOT rs.bof
        Set tempTable = Server.CreateObject("System.Collections.HashTable")
        tempTable.Add "prefix", rs("prefix").value
        tempTable.Add "next_no", rs("next_no").value
        aFilePrefix.Add tempTable
        rs.MoveNext
    Loop
    rs.Close()
    Set GetAllPrefixes = aFilePrefix
End Function


Function GetCarrierInfo(keyCol,orgNum)
    Dim result,sqlTxt,rsObj
    result = ""
    If orgNum <> "" Then
        sqlTxt= "select * from organization where elt_account_number=" & elt_account_number _
            & " and org_account_number=" & orgNum 

	    Set rsObj = Server.CreateObject("ADODB.Recordset")
	    rsObj.Open sqlTxt, eltConn, , , adCmdText
    	
	    If Not rsObj.EOF And Not rsObj.BOF Then
	        result = rsObj(keyCol).value
	    End If
	    rsObj.Close()
	    Set rsObj = Nothing
	End If
	
	GetCarrierInfo = result
End Function

Function GetCarrierCode(vMAWB)
    Dim result,sqlTxt,rsObj
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    result = ""
    sqlTxt= "select a.* from mawb_number a left outer join organization b " _
        & "on (a.Carrier_acct=b.org_account_number and a.elt_account_number=b.elt_account_number)" _
        & "where a.elt_account_number=" & elt_account_number & " and a.mawb_no=N'" & vMAWB & "'"

	rsObj.Open sqlTxt, eltConn, , , adCmdText
	
	If Not rsObj.EOF And Not rsObj.BOF Then
	    result = rsObj("carrier_code").value
	End If
	GetCarrierCode = result

    rsObj.Close()
End Function

Function GetSQLResult(sqlTxt,fName)
    Dim result,rsObj

    Set rsObj = Server.CreateObject("ADODB.Recordset")
    result = ""
    
	rsObj.Open sqlTxt, eltConn, , , adCmdText
	
	If Not rsObj.EOF And Not rsObj.BOF Then
	    If Not IsNull(fName) Then
	        result = rsObj(fName).value
	    Else
	        result = rsObj(0).value
	    End If
	End If

	GetSQLResult = checkBlank(result,"")

    rsObj.Close()
End Function


Function Stream_StringToBinary(Text, CharSet)
  Const adTypeText = 2
  Const adTypeBinary = 1
  
  'Create Stream object
  Dim BinaryStream 'As New Stream
  Set BinaryStream = CreateObject("ADODB.Stream")
  
  'Specify stream type - we want To save text/string data.
  BinaryStream.Type = adTypeText
  
  'Specify charset For the source text (unicode) data.
  If Len(CharSet) > 0 Then
    BinaryStream.CharSet = CharSet
  Else
    BinaryStream.CharSet = "us-ascii"
  End If
  
  'Open the stream And write text/string data To the object
  BinaryStream.Open
  BinaryStream.WriteText Text
  
  
  'Change stream type To binary
  BinaryStream.Position = 0
  BinaryStream.Type = adTypeBinary
  
  'Ignore first two bytes - sign of
  BinaryStream.Position = 0
  
  'Open the stream And get binary data from the object
  Stream_StringToBinary = BinaryStream.Read
End Function

Function GetAgentCountry()

    Dim result,rsObj,SQL
    
    SQL = "SELECT b.country_name FROM agent a LEFT OUTER JOIN all_country_code b " _
        & "ON (ISNULL(a.country_code,'US')=b.country_code) WHERE a.elt_account_number=" & elt_account_number
    
    
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    result = ""
    
	rsObj.Open SQL, eltConn, , , adCmdText
	
	If Not rsObj.EOF And Not rsObj.BOF Then
	    result = rsObj(0).value
	End If
    
	GetAgentCountry = result
	
End Function


Function GetGLDesc(glAcct)

    Dim result,rsObj,SQL
    
    SQL = "SELECT gl_account_desc FROM gl WHERE gl_account_number=" & glAcct _
        & " AND elt_account_number=" & elt_account_number
    
    Set rsObj = Server.CreateObject("ADODB.Recordset")
    result = ""
    
    On Error Resume Next:
	rsObj.Open SQL, eltConn, , , adCmdText
	
	If Not rsObj.EOF And Not rsObj.BOF Then
	    result = rsObj(0).value
	End If
    
	GetGLDesc = result
	
End Function

%>