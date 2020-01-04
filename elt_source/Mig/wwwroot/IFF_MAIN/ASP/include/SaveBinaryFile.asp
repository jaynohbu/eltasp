<%

'// Modifed by Joon on Feb/07/2007 ///////////////////////////////////////

Sub ADD_TO_MAIL(oMail, aEmail)
    Dim addrCnt, MyArray, MailCnt
    
    If aEmail = "" Then Exit Sub
	
	If InStr(1, aEmail, ",") Then
	    MyArray = Split(aEmail, ",")
	Else
	    MyArray = Split(aEmail, ";")
	End If

	MailCnt = Ubound(MyArray)
    For addrCnt = 0 To MailCnt
		If Not MyArray(addrCnt) = "" Then
			oMail.AddAddress MyArray(addrCnt)
		End If
	Next
End SUB

Sub ADD_CC_MAIL(oMail, aEmail)
    Dim  addrCnt, MyArray, MailCnt
    
    If aEmail = "" Then Exit Sub
	
	If InStr(1, aEmail, ",") Then
	    MyArray = Split(aEmail, ",")
	Else
	    MyArray = Split(aEmail, ";")
	End If

	MailCnt = Ubound(MyArray)
	For addrCnt = 0 To MailCnt
		If Not MyArray(addrCnt) = "" Then
			oMail.AddCC MyArray(addrCnt)
		End If
	Next
End SUB

'///////////////////////////////////////////////////////////////////////////
%>

<%
Sub SaveBinaryFile(OrgNo,FileName)
Dim Sql
Set fsoTmp = Server.CreateObject("Scripting.FileSystemObject")
If Not fsoTmp.FolderExists(temp_path) Then
	Set f = fsoTmp.CreateFolder(temp_path)
End If
If Not fsoTmp.FolderExists(temp_path & "\Eltdata") Then
	Set f = fsoTmp.CreateFolder(temp_path & "\Eltdata")
End If
If Not fsoTmp.FolderExists(temp_path & "\Eltdata\" & elt_account_number) Then
	Set f = fsoTmp.CreateFolder(temp_path & "\Eltdata\" & elt_account_number)
End If
if Not OrgNo="" then
	vDest=temp_path & "\Eltdata\" & elt_account_number & "\" & OrgNo
	If Not fsoTmp.FolderExists(vDest) Then
		Set f = fsoTmp.CreateFolder(vDest)
	End If
end if
Set fsoTmp=Nothing

if Not OrgNo="" And Not FileName="" then
	Set rsTmp = Server.CreateObject("ADODB.Recordset")
	SQL= "select * from user_files where elt_account_number=" & elt_account_number & " and org_no=" & OrgNo & " and file_name='" & FileName & "'"
	rsTmp.Open SQL, eltConn, , , adCmdText
	If Not rsTmp.EOF Then
		FileName=rsTmp("file_name")
		 'Create Stream object
  		Dim BinaryStream
  		Set BinaryStream = CreateObject("ADODB.Stream")

  		'Specify stream type - we want To save binary data.
  		BinaryStream.Type = adTypeBinary

 		'Open the stream And write binary data To the object
  		BinaryStream.Open
  		BinaryStream.Write rsTmp("file_content")

 		'Save binary data To disk
  		BinaryStream.SaveToFile vDest & "\" & FileName, adSaveCreateOverWrite
	End If
	rsTmp.close
	Set rsTmp=Nothing
End If
End Sub
%>