<%
' Variables
    ' Template and Output files
    varOutputFile = Server.MapPath("output.pdf")
    varInputFile = Server.MapPath("template.pdf")

    ' Populate data variables
    varField = "field"
    varImage = Server.MapPath("image.jpg")
    varFlag = "-995"

' Instantiate Object
Set TK = Server.CreateObject("APToolkit.Object")

' OpenOutputFile
varReturn = TK.OpenOutputFile(varOutputFile)
If varReturn <> 0 Then Error("OpenOutputFile") End If

' OpenInputFile
varReturn = TK.OpenInputFile(varInputFile)
If varReturn <> 0 Then Error("OpenInputFile") End If

' Populate the form field
TK.SetFormFieldData varField, varImage, varFlag

' CopyForm
varReturn = TK.CopyForm (0, 0)
If varReturn <> 1 Then Error("CopyForm") End If

' CloseOutputFile
TK.CloseOutputFile

' Release Object
Set TK = Nothing

' Done
Response.Write "Success!"

' Error Handling
Sub Error(Method)
    Response.Write "'" & Method & "' failed with a '" & varReturn & "'<br>"
    Response.Write "<a href='http://www.activepdf.com/support/kb/?id=10670&tk=ts'>"
    Response.Write "TK Return Codes</a>"
    Set TK = Nothing
    Response.End
End Sub
%>