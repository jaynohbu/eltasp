<%

'// Integer,Amount,String,Date

Function ConvertAnyValue(inputVal,DataType,defaultVal)
    Dim returnVal
    
    Select Case DataType
    
        Case "Long"
            returnVal = CLngPlus(inputVal,defaultVal)
        Case "Integer"
            returnVal = CLngPlus(inputVal,defaultVal)
        Case "Amount"
            returnVal = AmountPlus(inputVal,defaultVal)
        Case "String"
            returnVal = StringPlus(inputVal,defaultVal)
        Case "Date"
            returnVal = CDatePlus(inputVal,defaultVal)
        Case "Double"
            returnVal = CDblPlus(inputVal,defaultVal)
    End Select
    
    ConvertAnyValue = returnVal
End Function


'// Converts anyobject into vbLong

Function CLngPlus(inputVal,defaultVal)

    Dim returnVal
    On Error Resume Next:
    returnVal = defaultVal
    Select Case VarType(inputVal)
    
        Case vbEmpty
            returnVal = defaultVal
        Case vbNull
            returnVal = defaultVal
        Case vbInteger
            returnVal = CLng(inputVal)
        Case vbLong
            returnVal = CLng(inputVal)
        Case vbSingle
			returnVal = CLng(inputVal)
        Case vbDouble
			returnVal = CLng(inputVal)
        Case vbCurrency
		    returnVal = CLng(inputVal)  
        Case vbDate
			returnVal = CLng(inputVal)
        Case vbString
            If isNumeric(inputVal) Then
			    returnVal = CLng(inputVal)
			End If
        Case vbObject
	        returnVal = CLng(inputVal)   
        Case vbError
            '// Do nothing for now
            returnVal = inputVal 
        Case vbBoolean
            '// Do nothing for now
            returnVal = inputVal 
        Case vbVariant
            '// Do nothing for now
            returnVal = inputVal 
        Case vbDataObject
            '// Do nothing for now
            returnVal = inputVal 
        Case vbByte
            '// Do nothing for now
            returnVal = inputVal 
        Case vbArray
            '// Do nothing for now
            returnVal = inputVal 
        Case vbDecimal
            returnVal = CLng(inputVal)
            
    End Select

    CLngPlus = returnVal
End Function

Function AmountPlus(inputVal,defaultVal)

    Dim returnVal
    On Error Resume Next:
    returnVal = defaultVal
    Select Case VarType(inputVal)
    
        Case vbEmpty
            returnVal = defaultVal
        Case vbNull
            returnVal = defaultVal
        Case vbInteger
            returnVal = FormatNumber(inputVal,2,,,0)
        Case vbLong
	        returnVal = FormatNumber(inputVal,2,,,0)      
        Case vbSingle
	        returnVal = FormatNumber(inputVal,2,,,0)        
        Case vbDouble
	        returnVal = FormatNumber(inputVal,2,,,0)			
        Case vbCurrency
	        returnVal = inputVal        
        Case vbDate
	        returnVal = defaultVal        
        Case vbString
	       if isnumeric(inputVal)=false then
		        returnVal = defaultVal
		    else
				returnVal = FormatNumber(inputVal,2,,,0)
			end if         
        Case vbObject
	        returnVal = defaultVal         
        Case vbError
            '// Do nothing for now
            returnVal = inputVal
        Case vbBoolean
            returnVal = defaultVal
        Case vbVariant
            '// Do nothing for now
            returnVal = inputVal
        Case vbDataObject
            '// Do nothing for now
            returnVal = inputVal
        Case vbByte
            '// Do nothing for now
            returnVal = inputVal
        Case vbArray
            '// Do nothing for now
            returnVal = inputVal
        Case vbDecimal
            returnVal = FormatNumber(inputVal,2,,,0)
            
    End Select

    AmountPlus = returnVal
End Function

Function CDblPlus(inputVal,defaultVal)

    Dim returnVal
    On Error Resume Next:
    returnVal = defaultVal
    Select Case VarType(inputVal)
    
        Case vbEmpty
            returnVal = defaultVal
        Case vbNull
            returnVal = defaultVal
        Case vbInteger
            returnVal = CDbl(inputVal)
        Case vbLong
	        returnVal = CDbl(inputVal)     
        Case vbSingle
	        returnVal = CDbl(inputVal)     
        Case vbDouble
	        returnVal = inputVal			
        Case vbCurrency
	        returnVal = CDbl(inputVal)     
        Case vbDate
	        returnVal = defaultVal        
        Case vbString
	       if isnumeric(inputVal)=false then
		        returnVal = defaultVal
		    else
				returnVal = CDbl(inputVal)
			end if         
        Case vbObject
	        returnVal = defaultVal         
        Case vbError
            '// Do nothing for now
            returnVal = inputVal
        Case vbBoolean
            returnVal = defaultVal
        Case vbVariant
            '// Do nothing for now
            returnVal = inputVal
        Case vbDataObject
            '// Do nothing for now
            returnVal = inputVal
        Case vbByte
            '// Do nothing for now
            returnVal = inputVal
        Case vbArray
            '// Do nothing for now
            returnVal = inputVal
        Case vbDecimal
            returnVal = CDbl(inputVal)
            
    End Select

    CDblPlus = returnVal
End Function

Function StringPlus(inputVal,defaultVal)

    Dim returnVal
    On Error Resume Next:
    returnVal = defaultVal
    Select Case VarType(inputVal)
    
        Case vbEmpty
            returnVal = defaultVal
        Case vbNull
            returnVal = defaultVal
        Case vbInteger
            returnVal = CStr(inputVal)
        Case vbLong
	        returnVal = CStr(inputVal)        
        Case vbSingle
	        returnVal = CStr(inputVal)        
        Case vbDouble
	        returnVal = CStr(inputVal)        
        Case vbCurrency
	        returnVal = CStr(inputVal)       
        Case vbDate
	        returnVal = CStr(inputVal)        
        Case vbString
			returnVal = Trim(inputVal)
        Case vbObject
            '// Do nothing for now
	        returnVal = inputVal        
        Case vbError
            '// Do nothing for now
            returnVal = inputVal
        Case vbBoolean
            returnVal = defaultVal
        Case vbVariant
            '// Do nothing for now
            returnVal = inputVal
        Case vbDataObject
            '// Do nothing for now
            returnVal = inputVal
        Case vbByte
            '// Do nothing for now
            returnVal = inputVal
        Case vbArray
            '// Do nothing for now
            returnVal = inputVal
        Case vbDecimal
            returnVal = CStr(inputVal)  
    End Select
    StringPlus = returnVal
End Function

Function CDatePlus(inputVal,defaultVal)

    Dim returnVal
    On Error Resume Next:
    returnVal = defaultVal
    Select Case VarType(inputVal)
    
        Case vbEmpty
            returnVal = defaultVal
        Case vbNull
            returnVal = defaultVal
        Case vbInteger
	        returnVal = CDate(inputVal)           
        Case vbLong
	        returnVal = CDate(inputVal)        
        Case vbSingle
	        returnVal = CDate(defaultVal)         
        Case vbDouble
	        returnVal = CDate(inputVal)        
        Case vbCurrency
	        returnVal = CDate(defaultVal)       
        Case vbDate
	        returnVal = CDate(inputVal)        
        Case vbString
			if CDate(inputVal)=false then
		        returnVal = defaultVal
		    else
				returnVal = CDate(inputVal)  
			end if  
        Case vbObject
	        returnVal = CDate(defaultVal)          
        Case vbError
            '// Do nothing for now
            returnVal = defaultVal
        Case vbBoolean
            returnVal = defaultVal
        Case vbVariant
            '// Do nothing for now
            returnVal = inputVal
        Case vbDataObject
            '// Do nothing for now
            returnVal = inputVal
        Case vbByte
            '// Do nothing for now
            returnVal = inputVal
        Case vbArray
            '// Do nothing for now
            returnVal = inputVal
        Case vbDecimal
            returnVal = inputVal
            
    End Select

    CDatePlus = returnVal
End Function



%>