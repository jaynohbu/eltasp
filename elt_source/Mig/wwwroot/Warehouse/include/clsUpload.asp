<!--METADATA
	TYPE="TypeLib"
	NAME="Microsoft ActiveX Data Objects 2.5 Library"
	UUID="{00000205-0000-0010-8000-00AA006D2EA4}"
	VERSION="2.5"
-->
<%
Const FileSystemObjectEnabled = True
	' If your ISP does not allow the File System Object to
	' be used, then set this value to false.  Some features
	' will be disabled such as verifying folders exist,
	' Assigning unique names to files, displaying progress,
	' and interacting with existing files (Move, Copy, Delete,
	' Rename)

Const BufferSize = &H10000
	' Changing buffer size may change the length of time
	' it takes to upload a file.  You may want to begin
	' with 64KB and go from there to find the optimal
	' number for your website.

	' Since the Progress Information class writes to
	' a file each itteration, this can degrade performance
	' a lot when using small buffers.

	' Do not go below 100 bytes, or you will begin to risk
	' not being able to parse boundaries.  Data may not upload
	' properly.

	' For your reference:
	' 1 KB		1024		&H400
	' 2 KB		2048		&H800
	' 4 KB		4096		&H1000
	' 8 KB		8192		&H2000
	' 16 KB		16384		&H4000
	' 32 KB		32768		&H8000
	' 64 KB		65536		&H10000
	' 128 KB	131072		&H20000
	' 256 KB	262144		&H40000

%>
<!--#INCLUDE FILE="clsField.asp"-->
<!--#INCLUDE FILE="clsProgress.asp"-->
<%
' ------------------------------------------------------------------------------
'	Author:		Lewis Moten
'	Email:		Lewis@Moten.com
'	URL:		http://www.lewismoten.com
'	Date:		September 1, 2003
' ------------------------------------------------------------------------------

' Upload class retrieves multi-part form data posted to web page
' and parses it into objects that are easy to interface with.
' Requires MDAC (ADODB) COM components found on most servers today
' Additional compenents are not necessary.
'
' Demo:
'	Set objUpload = new clsUpload
'		Initializes object and parses all posted multi-part from data.
'		Once this as been done, Access to the Request object is restricted
'
'	objUpload.Count
'		Number of fields retrieved
'
'		use: Response.Write "There are " & objUpload.Count & " fields."
'
'	objUpload.Fields
'		Access to field objects.  This is the default propert so it does
'		not necessarily have to be specified.  You can also determine if
'		you wish to specify the field index, or the field name.
'
'		Use:
'			Set objField = objUpload.Fields("File1")
'			Set objField = objUpload("File1")
'			Set objField = objUpload.Fields(0)
'			Set objField = objUpload(0)
'			Response.Write objUpload("File1").Name
'			Response.Write objUpload(0).Name
'
' ------------------------------------------------------------------------------
'
' List of all fields passed:
'
'	For i = 0 To objUpload.Count - 1
'		Response.Write objUpload(i).Name & "<BR>"
'	Next
'
' ------------------------------------------------------------------------------
'
' HTML needed to post multipart/form-data
'
'<FORM method="post" encType="multipart/form-data" action="Upload.asp">
'	<INPUT type="File" name="File1">
'	<INPUT type="Submit" value="Upload">
'</FORM>

' ------------------------------------------------------------------------------
'
' Customized Errors:
' (vbObjectError + ##)
'
' 1:  Object does not exist within the ordinal reference.
' 2:  Failed to save file ... common reasons
' 3:  Failed to parse posted binary data delimiter
' 4:  Failed to save file ... unknown
' 5:  Used Request.Form ... Failed to read posted form data
' 6:  Failed to read posted form data for unknown reason.
' 7:  Folder does not exist.
' 8:  Filename is not valid
' 9:  Folder is not valid
' 10: ADODB.Version below 2.5
' 11: Not enough free space available.
' 12: File System Object has been disabled.
' 13: multipart/form-data was not received.
' ------------------------------------------------------------------------------
'
Dim gBinaryData		' bytes visitor sent to server with posted form data
					' Page Scope accessable to both clsUpload and clsFile

Class clsUpload
' ------------------------------------------------------------------------------

	Private TotalBytes			' Number of bytes client is sending
	Private Delimiter			' Delimiter between multipart/form-data (43 chars)

	Private CR					' ANSI Carriage Return
	Private LF					' ANSI Line Feed
	Private CRLF				' ANSI Carriage Return & Line Feed

	Private mobjFieldAry()		' Array to hold field objects
	Private mlngCount			' Number of fields parsed
	Private msg					' Error Message

	Private ProductName			' Name of the product
	Private ProductVersion		' Version of the product
	Private ErrorSignature		' Signature applied to all products.

	Private Progress			' Progress information class
	Private ParsedData			' Did we parse the data?
' ------------------------------------------------------------------------------
	Private Sub RequestData

		If ParsedData Then Exit Sub
		ParsedData = True

		'On Error Resume Next

		' Determine number bytes visitor sent
		TotalBytes = Request.TotalBytes

		Dim ChunkSize
		Dim Received
		Dim TotalBytes
		Dim BinaryStream

		ChunkSize = BufferSize ' Global Property

		TotalBytes = Request.TotalBytes

		Received = 0

		Set BinaryStream = CreateObject("ADODB.Stream")

		BinaryStream.Mode = adModeReadWrite

		BinaryStream.Type = adTypeBinary

		BinaryStream.Open

		Do While ChunkSize > 0

			' If chunk size buffer will read past the end of the stream
			' adjust it to read to the end of the stream.
			If ChunkSize + Received > TotalBytes Then ChunkSize = TotalBytes - Received

			' get out of the loop if no more data can be read.
			If ChunkSize = 0 Then Exit Do

			' Get the current chunk
			' Write chunk to stream
			BinaryStream.Write(Request.BinaryRead(ChunkSize))

			' Incriment bytes received
			Received = Received + ChunkSize

			' As long as the user is still connected ...
			If Response.IsClientConnected() Then

				' Update Progress information
				Progress.LastActive = Now()
				Progress.BytesReceived = Received
				Call Progress.Save()

			Else

				' Update Progress information
				Progress.UploadCompleted = Now()
				Call Progress.Save()

				' Stop execution.
				Exit Sub

			End If

		Loop

		BinaryStream.Position = 0

		gBinaryData = BinaryStream.Read(adReadAll)

		BinaryStream.Close

		Set BinaryStream = Nothing

		' Parse out the delimiter
		Delimiter = ParseBoundary()

		' Parse the data
		Call ParseData
	End Sub


' ------------------------------------------------------------------------------
'	Private Function ParseDelimiter()
'
'		' Delimiter seperates multiple pieces of form data
'			' "around" 43 characters in length
'			' next character afterwards is carriage return (except last line has two --)
'			' first part of delmiter is dashes followed by hex number
'			' hex number is possibly the browsers session id?
'
'		' Need a MAC to find out why this causes problems.
'
'		' MSIE 3.01 and 3.02 on the Mac, for instance, don't use a
'		' leading '--' in the boundary field for multipart/form-data POSTs
'
'		' Examples:
'
'		' -----------------------------7d230d1f940246
'		' -----------------------------7d22ee291ae0114
'
'		' If we can not find a carriage return and line feed combination ...
'		If InStrB(1, gBinaryData, CRLF) = 0 Then
'
'			' We can not determine the delimiter
'
'			msg = "Failed to parse posted binary data delimiter.  "
'			msg = msg & " Make sure your encoding attiribute is set to"
'			msg = msg & " mutlipart/form-data in your <FORM> tag.  example:"
'			msg = msg & "<FORM method=""post"" encType=""multipart/form-data"""
'			msg = msg & " action=""ToDatabase.asp""> "
'
'			Call PublishError(3, msg)
'
'			Exit Sub
'
'		End If
'
'		' parse delimiter
'		ParseDelimiter = MidB(gBinaryData, 1, InStrB(1, gBinaryData, CRLF) - 1)
'
'	End Function
' ------------------------------------------------------------------------------
	Private Function IsMultipartFormData()

		' Determine if user posted multipart form-data

		' if not, they did not specify encType attribute correctly
		' on <FORM> tag.

		Dim ContentType

		ContentType = Request.ServerVariables("HTTP_CONTENT_TYPE")

		' Return true, only if the text is found within the content type.
		IsMultipartFormData = Not InStr(1, ContentType, "multipart/form-data") = 0

	End Function
' ------------------------------------------------------------------------------
	Private Function ParseBoundary()

		' Parse boundary from content type

		' The boundry seperates each type of data within the binary data posted
		' to this web page.

		' NOTE: Not sure if this new technique solves issues with
		'	MAC
		'	MSIE 3.01 & 3.02 on MAC.
		'	Opera
		'	Mozilla 1.2
		'
		'	Could not confirm issues in the past or now.  If you are a developer
		'	and have access to these resources, please help me verify if the
		'	code does or does not work.

		Dim ContentType
		Dim BoundaryIndex

		ContentType = Request.ServerVariables("HTTP_CONTENT_TYPE")

		' Find out where the boundary text starts
		BoundaryIndex = InStr(1, ContentType, "boundary=")

		' If boundary is not specified withing content type header
		If BoundaryIndex = 0 Then

			' Return nothing.
			Exit Function

		End If

		' Pull the boundary out of the content type
		' Len("boundary=") = 9
		ParseBoundary = CStrB(Mid(ContentType, BoundaryIndex + 9))

	End Function
' ------------------------------------------------------------------------------
	Private Sub ParseData()

		' This procedure loops through each section (chunk) found within the
		' delimiters and sends them to the parse chunk routine

		Dim ChunkStart	' start position of chunk data
		Dim ChunkLength	' Length of chunk
		Dim ChunkEnd	' Last position of chunk data

		' Initialize at first character
		ChunkStart = 1

		' Find start position
		ChunkStart = InStrB(ChunkStart, gBinaryData, Delimiter & CRLF)

		' While the start posotion was found
		While Not ChunkStart = 0

			' Find the end position (after the start position)
			ChunkEnd = InStrB(ChunkStart + 1, gBinaryData, Delimiter) - 2

			' Determine Length of chunk
			ChunkLength = ChunkEnd - ChunkStart

			Call ParseChunk(ChunkStart, ChunkLength)

			' Look for next chunk after the start position
' ChunkStart = InStrB(ChunkStart + 1, gBinaryData, Delimiter & CRLF)
			ChunkStart = InStrB(ChunkEnd, gBinaryData, Delimiter & CRLF)

		Wend
	End Sub
' ------------------------------------------------------------------------------
	Private Sub ParseChunk(ByRef chunkStart, ByRef chunkLength)

		' This procedure gets a chunk passed to it and parses its contents.
		' There is a general format that the chunk follows.

		' First, the deliminator appears

		' Next, headers are listed on each line that define properties of the chunk.

		'	Content-Disposition: form-data: name="File1"; filename="C:\Photo.gif"
		'	Content-Type: image/gif

		' After this, a blank line appears and is followed by the binary data.

		Dim FieldName			' Name of field
		Dim FilePath			' File name of binary data
		Dim ContentType			' Content type of binary data
		Dim ContentDisposition	' Content Disposition
		Dim dataStart			' Start position of data
		Dim dataLength			' Length of data

		' Parse out the content dispostion
		ContentDisposition = ParseDisposition(chunkStart, chunkLength)

			' And Parse the Name
			FieldName = ParseName(ContentDisposition)

			' And the file name
			FilePath = ParseFileName(ContentDisposition)

		' Parse out the Content Type
		ContentType = ParseContentType(chunkStart, chunkLength)

		' Determine where the binardy data begins and ends
		Call ParseBinaryData(chunkStart, chunkLength, dataStart, dataLength)

		' Add a new field
		Call AddField(FieldName, FilePath, ContentType, dataStart, dataLength)

	End Sub
' ------------------------------------------------------------------------------
	Private Sub AddField(ByRef fieldName, ByRef filePath, ByRef contentType, ByRef dataStart, ByRef dataLength)

		Dim Field		' Field object class

		' Add a new index to the field array
		' Make certain not to destroy current fields
		ReDim Preserve mobjFieldAry(mlngCount)

		' Create new field object
		Set Field = New clsField

		' Set field properties
		With Field
			.Name = fieldName
			.FilePath = filePath
			.ContentType = contentType
			.dataStart = dataStart
			.dataLength = dataLength
		End With


		' Determine field length based on if ContentType was provided.
		If contentType = "" Then

			' Assume Unicode - 2 bytes per character
			Field.Length = dataLength \ 2

		Else

			' Assume binary data
			Field.Length = dataLength

		End If

		' Set field array index to new field
		Set mobjFieldAry(mlngCount) = Field

		' Incriment field count
		mlngCount = mlngCount + 1

	End Sub
' ------------------------------------------------------------------------------
	Private Sub ParseBinaryData(ByRef chunkStart, ByRef chunkLength, ByRef dataStart, ByRef dataLength)

		' Parses binary content of the chunk

		dataStart = 0
		dataLength = 0

		' Find first occurence of a blank line
		dataStart = InStrB(chunkStart, gBinaryData, CRLF & CRLF)

		' If it doesn't exist, then return nothing
		If dataStart = 0 Then Exit Sub
		If dataStart > chunkStart + chunkLength Then
			dataStart = 0
			Exit Sub
		End If

		' Incriment start to pass carriage returns and line feeds
		dataStart = dataStart + 4

		' calculate data length based on start and length of the chunk.
		dataLength = ((chunkStart + chunkLength) - dataStart)

	End Sub
' ------------------------------------------------------------------------------
	Private Function ParseContentType(ByRef chunkStart, ByRef chunkLength)

		' Parses the content type of a binary file.
		'	example: image/gif is the content type of a GIF image.

		Dim StartIndex	' Start Position
		Dim EndIndex	' End Position
		Dim Length		' Length

		' Fid the first occurance of a line starting with Content-Type:
		StartIndex = InStrB(chunkStart, gBinaryData, CRLF & CStrB("Content-Type:"), vbTextCompare)

		' If not found, return nothing
		If StartIndex = 0 Or StartIndex > chunkStart + chunkLength Then
			ParseContentType = ""
			Exit Function
		End If

		' Find the end of the line
		EndIndex = InStrB(StartIndex + 15, gBinaryData, CR)

		' If not found, return nothing
		If EndIndex = 0 Or endIndex > chunkStart + chunkLength Then
			ParseContentType = ""
			Exit Function
		End If

		' Adjust start position to start after the text "Content-Type:"
		StartIndex = StartIndex + 15

		' If the start position is the same or past the end, return nothing
		If StartIndex >= EndIndex Then
			ParseContentType = ""
			Exit Function
		End If

		' Determine length
		Length = EndIndex - StartIndex

		' Pull out content type
		' Convert to unicode
		' Trim out whitespace
		' Return results
		ParseContentType = Trim(CStrU(MidB(gBinaryData, StartIndex, Length)))

	End Function
' ------------------------------------------------------------------------------
	Private Function ParseDisposition(ByRef chunkStart, ByRef chunkLength)

		' Parses the content-disposition from a chunk of data
		'
		' Example:
		'
		'	Content-Disposition: form-data: name="File1"; filename="C:\Photo.gif"
		'
		'	Would Return:
		'		form-data: name="File1"; filename="C:\Photo.gif"

		Dim StartIndex	' Start Position
		Dim EndIndex	' End Position
		Dim Length	' Length

		' Find first occurance of a line starting with Content-Disposition:
		StartIndex = InStrB(chunkStart, gBinaryData, CRLF & CStrB("Content-Disposition:"), vbTextCompare)

		' If not found, return nothing
		If StartIndex = 0 Or StartIndex > chunkStart + chunkLength Then Exit Function

		' Find the end of the line
		EndIndex = InStrB(StartIndex + 22, gBinaryData, CRLF)

		' If not found, return nothing
		If EndIndex = 0 Or EndIndex > chunkStart + chunkLength Then Exit Function

		' Adjust start position to start after the text "Content-Disposition:"
		StartIndex = StartIndex + 22

		' If the start position is the same or past the end, return nothing
		If StartIndex >= EndIndex Then Exit Function

		' Determine Length
		Length = EndIndex - StartIndex

		' Pull out content disposition
		' Convert to Unicode
		' Return Results
		ParseDisposition = CStrU(MidB(gBinaryData, StartIndex, Length))

	End Function
' ------------------------------------------------------------------------------
	Private Function ParseName(ByRef contentDisposition)

		' Parses the name of the field from the content disposition
		'
		' Example
		'
		'	form-data: name="File1"; filename="C:\Photo.gif"
		'
		'	Would Return:
		'		File1

		Dim StartIndex	' Start Position
		Dim EndIndex		' End Position
		Dim Length	' Length

		' Find first occurance of text name="
		StartIndex = InStr(1, contentDisposition, "name=""", vbTextCompare)

		' If not found, return nothing
		If StartIndex = 0 Then Exit Function

		' Find the closing quote
		EndIndex = InStr(StartIndex + 6, contentDisposition, """")

		' If not found, return nothing
		If EndIndex = 0 Then Exit Function

		' Adjust start position to start after the text name="
		StartIndex = StartIndex + 6

		' If the start position is the same or past the end, return nothing
		If StartIndex >= EndIndex Then Exit Function

		' Determine Length
		Length = EndIndex - StartIndex

		' Pull out field name
		' Return results
		ParseName = Mid(contentDisposition, StartIndex, Length)

	End Function
' ------------------------------------------------------------------------------
	Private Function ParseFileName(ByRef pstrDisposition)
		' Parses the name of the field from the content disposition
		'
		' Example
		'
		'	form-data: name="File1"; filename="C:\Photo.gif"
		'
		'	Would Return:
		'		C:\Photo.gif

		Dim llngStart	' Start Position
		Dim llngEnd		' End Position
		Dim llngLength	' Length

		' Find first occurance of text filename="
		llngStart = InStr(1, pstrDisposition, "filename=""", vbTextCompare)

		' If not found, return nothing
		If llngStart = 0 Then
			ParseFileName = DefaultName()
			Exit Function
		End If

		' Find the closing quote
		llngEnd = InStr(llngStart + 10, pstrDisposition, """")

		' If not found, return nothing
		If llngEnd = 0 Then
			ParseFileName = DefaultName()
			Exit Function
		End If


		' Adjust start position to start after the text filename="
		llngStart = llngStart + 10

		' If the start position is the same of past the end, return nothing
		If llngStart >= llngEnd Then
			ParseFileName = DefaultName()
			Exit Function
		End If

		' Determine length
		llngLength = llngEnd - llngStart

		' Pull out file name
		' Return results
		ParseFileName = Mid(pstrDisposition, llngStart, llngLength)

	End Function
' ------------------------------------------------------------------------------
	Private Function DefaultName()
		' Some browsers don't supply file names in the headers.
		' We have to assume a name for them.
		' Since all we know is that the file is made of binary data,
		' we assign a .bin extension.
		DefaultName = _
			Year(Date) & "_" & _
			MonthName(Month(Date), True) & "_" & _
			Day(Date) & "-" & _
			timer() & ".bin"
	End Function
' ------------------------------------------------------------------------------
	Public Property Get Count()
		Call RequestData()

		' Return number of fields found
		Count = mlngCount

	End Property
' ------------------------------------------------------------------------------
	Public Property Get Collection(ByVal fieldName)

		Dim myCollection()
		Dim index
		Dim matches

		' convert name to lowercase
		fieldName = LCase(fieldName)

		' default number of matches to none
		matches = -1

		' Loop through each field
		For index = 0 to Count() - 1

			' If name matches
			If LCase(mobjFieldAry(index).Name) = fieldName Then

				' incriment number of matches found
				matches = matches + 1

				' Add a new item to the collection
				ReDim Preserve myCollection(matches)

				' Assign last item to the value
				Set myCollection(matches) = mobjFieldAry(index)'.Value

			End If

		Next

		' Return the collection as an array
		Collection = myCollection

	End Property
' ------------------------------------------------------------------------------
	Public Default Property Get Fields(ByVal pstrName)

		Call RequestData()

		Dim llngIndex	' Index of current field

		' If a number was passed
		If IsNumeric(pstrName) Then

			llngIndex = CLng(pstrName)

			' If programmer requested an invalid number
			If llngIndex > mlngCount - 1 Or llngIndex < 0 Then
				' Raise an error
				Call PublishError(1, "Object does not exist within the ordinal reference.")
				Exit Property
			End If

			' Return the field class for the index specified
			Set Fields = mobjFieldAry(pstrName)

			Exit Property

		' Else a field name was passed
		Else

			' convert name to lowercase
			pstrName = LCase(pstrname)

			' Loop through each field
			For llngIndex = 0 To mlngCount - 1

				' If name matches current fields name in lowercase
				If LCase(mobjFieldAry(llngIndex).Name) = pstrName Then

					' Return Field Class
					Set Fields = mobjFieldAry(llngIndex)
					Exit Property

				End If

			Next

		End If

		' If matches were not found, return an empty field
		Set Fields = New clsField
	End Property
' ------------------------------------------------------------------------------
	Private Function CStrU(ByRef pstrANSI)

		' Converts an ANSI string to Unicode
		' Best used for small strings

		Dim llngLength	' Length of ANSI string
		Dim llngIndex	' Current position

		' determine length
		llngLength = LenB(pstrANSI)

		' Loop through each character
		For llngIndex = 1 To llngLength

			' Pull out ANSI character
			' Get Ascii value of ANSI character
			' Get Unicode Character from Ascii
			' Append character to results

			' Convert to unicode
			CStrU = CStrU & Chr(AscB(MidB(pstrANSI, llngIndex, 1)))

		Next

	End Function
' ------------------------------------------------------------------------------
	Private Function CStrB(ByRef pstrUnicode)

		' Converts a Unicode string to ANSI
		' Best used for small strings

		Dim llngLength	' Length of ANSI string
		Dim llngIndex	' Current position

		' determine length
		llngLength = Len(pstrUnicode)

		' Loop through each character
		For llngIndex = 1 To llngLength

			' Pull out Unicode character
			' Get Ascii value of Unicode character
			' Get ANSI Character from Ascii
			' Append character to results
			CStrB = CStrB & ChrB(Asc(Mid(pstrUnicode, llngIndex, 1)))

		Next

	End Function
' ------------------------------------------------------------------------------
	Public Sub DeleteFile(byval filePath)
		If Not FileSystemObjectEnabled Then
			Call PublishError(12, "File System Object has been disabled.")
			Exit Sub
		End If

		Dim FSO
		Set FSO = CreateObject("Scripting.FileSystemObject")
		FSO.DeleteFile(filePath)
		Set FSO = Nothing
	End Sub
' ------------------------------------------------------------------------------
	Public Sub RenameFile(ByVal filePath, ByVal fileName)
		If Not FileSystemObjectEnabled Then
			Call PublishError(12, "File System Object has been disabled.")
			Exit Sub
		End If
		Dim folder
		folder = Mid(filePath, 1, InStrRev(filePath, "\"))
		Dim FSO
		Set FSO = CreateObject("Scripting.FileSystemObject")
		Call FSO.MoveFile(filePath, folder & fileName)
		Set FSO = Nothing
	End Sub
' ------------------------------------------------------------------------------
	Public Sub CopyFile(ByRef source, ByRef destination)
		If Not FileSystemObjectEnabled Then
			Call PublishError(12, "File System Object has been disabled.")
			Exit Sub
		End If
		Dim FSO
		Set FSO = CreateObject("Scripting.FileSystemObject")
		Call FSO.CopyFile(source, destination, true)
		Set FSO = Nothing
	End Sub
' ------------------------------------------------------------------------------
	Public Sub MoveFile(ByRef source, ByRef destination)
		If Not FileSystemObjectEnabled Then
			Call PublishError(12, "File System Object has been disabled.")
			Exit Sub
		End If
		Dim FSO
		Set FSO = CreateObject("Scripting.FileSystemObject")
		Call FSO.MoveFile(source, destination)
		Set FSO = Nothing
	End Sub
' ------------------------------------------------------------------------------
	Public Function UniqueName(ByVal folder, ByRef proposedName)

		' Generates a unique file name that has not yet been used
		' within the target folder.

		' If we continue to upload a file called photo.gif,
		' this is what will be returned:

		' first time:	photo.gif
		' second time:	photo[1].gif
		' third time:	photo[2].gif

		If Not FileSystemObjectEnabled Then
			Call PublishError(12, "File System Object has been disabled.")
			Exit Function
		End If

		' Make sure we have a file name
		If proposedName = "" Then proposedName = DefaultName()

		' Make sure user supplied a valid file name
		If proposedName = "." Then
			Call PublishError(8, "Filename is not valid")
			Exit Function
		End If

		' Make sure user supplied a folder to check
		If folder = "" Then
			Call PublishError(9, "Folder is not valid")
			Exit Function
		End If

		Dim Name ' Name of file (without extension)
		Dim Ext ' File Extension

		' seperate name/ext
		If InStrRev(proposedName, ".") = 0 Then
			Name = proposedName
			Ext = ""
		ElseIf InStrRev(proposedName, ".") = 1 Then
			Name = ""
			Ext = Mid(proposedName, 2)
		ElseIf InStrRev(proposedName, ".") = Len(proposedName) Then
			Name = Mid(proposedName, 1, Len(proposedName) - 1)
			Ext = ""
		Else
			Name = Mid(proposedName, 1, InStrRev(proposedName, ".") - 1)
			Ext = Mid(proposedName, InStrRev(proposedName, ".") + 1)
		End If

		' make sure we have trailing slash
		If Not Mid(folder, Len(folder), 1) = "\" Then folder = folder & "\"

		Dim FSO
		Set FSO = CreateObject("Scripting.FileSystemObject")

		' verify folder exists
		If Not FSO.FolderExists(folder) Then
			Set FSO = Nothing
			Call PublishError(7, "Folder does not exist: " & folder)
			Exit Function
		End If

		Dim Suffix
		Dim Index

		Index = 0
		Suffix = ""

		' Check to see if compiled filename exists
		While FSO.FileExists(folder & Name & Suffix & "." & Ext)

			' File name exists, let's incriment our counter
			Index = Index + 1

			' Setup suffix to match the index
			Suffix = "[" & Index & "]"

		Wend

		Set FSO = Nothing

		' Return unique file name
		UniqueName = Name & Suffix & "." & Ext

	End Function
' ------------------------------------------------------------------------------
	Private Sub PublishError(number, message)
		' writes out error in a specific format.
		On Error Goto 0
		Call Err.Raise(vbObjectError + number, ProductName & " " & ProductVersion, message + ErrorSignature)
	End Sub
' ------------------------------------------------------------------------------
	Public Function DebugText()
Call RequestData()
		' Returns HTML code used in debugging the information comming accross
		' within the posted form data
		Dim Text
		Dim Length
		Dim Index
		Dim Code

		Length = LenB(gBinaryData)

		For Index = 1 To Length
			Code = AscB(MidB(gBinaryData, Index, 1))
			Select Case Code
				Case 13
					Text = Text & "<B>vbCr</B><BR>"
				Case 10
					Text = Text & "<B>vbLf</B><BR>"
			Case Else
				If Code < 32 Then

					' non-printable character
					Text = Text & "."

				Else

					' printable.  Encode the character.
					Text = Text & Server.HTMLEncode(Chr(Code))

				End If
			End Select
		Next

		DebugText = Text

	End Function
' ------------------------------------------------------------------------------
	Private Sub Class_Terminate()

		' This event is called when you destroy the class.
		'
		' Example:
		'	Set objUpload = Nothing
		'
		' Example:
		'	Response.End
		'
		' Example:
		'	Page finnishes executing ...

		' Remove binary data
		gBinaryData = ""

		Dim llngIndex	' Current Field Index

		' Loop through fields
		For llngIndex = 0 To mlngCount - 1

			' Release field object
			Set mobjFieldAry(llngIndex) = Nothing

		Next

		' Redimension array and remove all data within
		ReDim mobjFieldAry(-1)

		' Signify the upload process has been completed.
		Session("Upload.Completed") = Now()

		' Update Session
		Progress.UploadCompleted = Now()
		Call Progress.Save()

	End Sub
' ------------------------------------------------------------------------------
	Private Sub Class_Initialize()


		' This event is called when you instantiate the class.
		'
		' Example:
		'	Set objUpload = New clsUpload

		ProductName = "Upload Without COM"
		ProductVersion = "3.0"
		ErrorSignature = "[Need help?  Contact Lewis Moten, lewis@moten.com, http://www.lewismoten.com]"

 		' Initialize progress information class
		Set Progress = New clsProgress

		' Set initial information
		Progress.UploadStarted = Now()
		Progress.LastActive = Now()
		Progress.BytesReceived = 0
		Progress.TotalBytes = Request.TotalBytes
		Progress.UploadCompleted = ""

		' update the Progress information
		Call Progress.Save()

		' Set script timeout to 10 minutes.
		Server.ScriptTimeout = 60 * 10

		' Shameless plug for search engines
		'Response.Write "<NOSCRIPT>"
		'Response.Write "<B>Upload Files Without COM</B> provided by: "
		'Response.Write "<A href=""http://www.lewismoten.com""><I>Lewis Moten</I></A>"
		'Response.Write "</NOSCRIPT>"

		' Verify ADODB Version
		Dim Connection
		Dim AdodbVersion
		Set Connection = CreateObject("ADODB.Connection")
		AdodbVersion = CDbl(Connection.Version)
		Set Connection = Nothing

		If AdodbVersion < 2.5 Then
			Call PublishError(10, "Microsoft Data Access Components (ADODB) must be version 2.5 or above.")
			Exit Sub
		End If

		' Did the web developer program the form tag correctly?
		If Not IsMultipartFormData() Then

			msg = "multipart/form-data was not received.  "
			msg = msg & "Make sure that you have specified the endType "
			msg = msg & "attribute to ""multipart/form-data"" in your "
			msg = msg & "<FORM id=form1 name=form1> tag."

			Call PublishError(13, msg)
			Exit Sub

		End If

		' Redimension array with nothing
		ReDim mobjFieldAry(-1)

		' Compile ANSI equivilants of carriage returns and line feeds

		CR = ChrB(Asc(vbCr))	' vbCr		Carriage Return
		LF = ChrB(Asc(vbLf))	' vbLf		Line Feed
		CRLF = CR & LF			' vbCrLf	Carriage Return & Line Feed

		' Set field count to zero
		mlngCount = 0

		' Request data
'		Call RequestData
	End Sub
' ------------------------------------------------------------------------------
End Class
' ------------------------------------------------------------------------------
%>