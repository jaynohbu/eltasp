<html><body>

<!--

        <script type="text/jscript">
        function getFormObject(argObj){
    
        var form = argObj.parentElement;
        var newWindow;
        	        
            form.action = "../include/GOOFY_form_get.asp";
            form.method = "POST";
            window.open('', 'formTest');
            form.target = "formTest";
            form.submit();
        }
        </script>
        <input type=button value="form object" onclick="getFormObject(this)" />
        
-->

<% 


Call GetFormObjects(Request,Response)

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
    
    result = Replace(result,"&","<br/>")
    
    URLDecodePlus = result
End Function

%>


</body></html>

