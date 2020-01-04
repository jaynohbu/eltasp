<%
' ------------------------------------------------------------------------------
'	Author:		Lewis Moten
'	Email:		Lewis@Moten.com
'	URL:		http://www.lewismoten.com
'	Date:		March 19, 2002
' ------------------------------------------------------------------------------

' Field class represents interface to data passed within one field
'
' Two available methods of getting a field:
'	Set objField = objUpload.Fields("File1")
'	Set objField = objUpload("File1")
'
'
'	objField.Name
'		Name of the field as defined on the form
'
'	objFiled.Filepath
'		Path that file was sent from
'
'		ie: C:\Documents and Settings\lmoten\Desktop\Photo.gif
'
'	objField.FileDir
'		Directory that file was sent from
'
'		ie: C:\Documents and Settings\lmoten\Desktop
'
'	objField.FileExt
'		Uppercase Extension of the file
'
'		ie: GIF
'
'	objField.FileName
'		Name of the file
'
'		use: Response.AddHeader "Content-Disposition", "filename=""" & objField.FileName & """"
'
'		ie: Photo.gif
'
'	objField.ContentType
'		Type of binary data
'
'		use: Response.ContentType = objField.ContentType
'
'		ie: image/gif
'
'	objField.Value
'		Unicode value passed from form.  This value is empty if the field is binary data.
'
'		use: Response.Write "The value of this field is: " & objField.Value
'
'	objField.BinaryData
'		Contents of files binary data. (Integer SubType Array)
'
'		use: Response.BinaryWrite objField.BinaryData
'
'	objField.BLOB
'		Same thing as BinaryData but with a shorter name.  Added to help prevent
'		confusion with database access.
'
'		use: Call lobjRs.Fields("Image").AppendChunk(objField.BLOB)
'
'	objField.Length
'		byte size of Value or BinaryData - depending on type of field
'
'		use: Response.Write "The size of this file is: " & objField.Length
'
'	objField.BinaryAsText()
'		Converts binary data into unicode format.  Useful when you expect the user
'		to upload a text file and you have the need to interact with it.
'
'		use: Response.Write objField.BinaryAsText()
'
'	objField.SaveAs()
'		Saves binary data to a specified path.  This will overwrite any existing files.
'
'		use: objField.SaveAs(Server.MapPath("/Uploads/") & "\" & objField.FileName)
'
'	objField.DataStart
'		location within all posted binary data where particular fields data begins.
'
'		use: FieldData = MidB(BinaryData, objField.DataStart, objField.DataLength)

'	objField.DataLength
'		length of the posted binary data
'
'		use: FieldData = MidB(BinaryData, objField.DataStart, objField.DataLength)


' ------------------------------------------------------------------------------
Class clsField

	Public Name				' Name of the field defined in form

	Private mstrPath		' Full path to file on visitors computer
							' C:\Documents and Settings\lmoten\Desktop\Photo.gif

	Public FileDir			' Directory that file existed in on visitors computer
							' C:\Documents and Settings\lmoten\Desktop

	Public FileExt			' Extension of the file
							' GIF

	Public FileName			' Name of the file
							' Photo.gif

	Public ContentType		' Content / Mime type of file
							' image/gif

'	Public Value			' Unicode value of field (used for normail form fields - not files)

'	Public BinaryData		' Binary data passed with field (for files)

	Public Length			' byte size of value or binary data

	Private mstrText		' Text buffer
								' If text format of binary data is requested more then
								' once, this value will be read to prevent extra processing

	Private msg				' Error Message

	Public DataStart		' Index where field data begins in posted data

	Public DataLength		' Length of field data within posted data

	Private ProductName
	Private ProductVersion
	Private ErrorSignature

' ------------------------------------------------------------------------------
	Public Property Get BLOB()
		BLOB = BinaryData
	End Property
' ------------------------------------------------------------------------------
	Public Property Get BinaryData()

		' Parses binary content of the chunk
		If DataStart = 0 Then Exit Property
		If DataLength = 0 Then Exit Property

		BinaryData = MidB(gBinaryData, DataStart, DataLength)

	End Property
' ------------------------------------------------------------------------------
	Public Property Get Value()
		'// Value = CStrU(BinaryData)
		Value = BinaryToString(BinaryData)
	End Property
	
	
    Private Function BinaryToString(Binary)
      Dim cl1, cl2, cl3, pl1, pl2, pl3
      Dim L
      cl1 = 1
      cl2 = 1
      cl3 = 1
      L = LenB(Binary)
      
      Do While cl1<=L
        pl3 = pl3 & Chr(AscB(MidB(Binary,cl1,1)))
        cl1 = cl1 + 1
        cl3 = cl3 + 1
        If cl3>300 Then
          pl2 = pl2 & pl3
          pl3 = ""
          cl3 = 1
          cl2 = cl2 + 1
          If cl2>200 Then
            pl1 = pl1 & pl2
            pl2 = ""
            cl2 = 1
          End If
        End If
      Loop
      BinaryToString = pl1 & pl2 & pl3
    End Function


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
			CStrU = CStrU & Chr(AscB(MidB(pstrANSI, llngIndex, 1)))
		Next

	End Function
' ------------------------------------------------------------------------------
	Public Function BinaryAsText()

		' Binary As Text returns the unicode equivilant of the binary data.
		' this is useful if you expect a visitor to upload a text file that
		' you will need to work with.

		' NOTICE:
		' NULL values will prematurely terminate your Unicode string.
		' NULLs are usually found within binary files more often then plain-text files.
		' a simple way around this may consist of replacing null values with another character
		' such as a space " "

		If ContentType = "" Then Exit Function
		If DataStart = 0 Then Exit Function
		If DataLength = 0 Then Exit Function

		' If we previously converted binary to text, return the buffered content
		If Not Len(mstrText) = 0 Then
			BinaryAsText = mstrText
			Exit Function
		End If

		' Convert Integer Subtype Array to Byte Subtype Array
		lbinBytes = ASCII2Bytes(BinaryData)

   		' Convert Byte Subtype Array to Unicode String
   		mstrText = Bytes2Unicode(lbinBytes)

   		' Return Unicode Text
    	BinaryAsText = mstrText

	End Function
' ------------------------------------------------------------------------------
	Public Sub SaveAs(ByRef pstrFileName)

		If FileSystemObjectEnabled Then

			Dim FSO
			Dim Folder

			Set FSO = CreateObject("Scripting.FileSystemObject")
			Folder = FSO.GetParentFolderName(pstrFileName)

			' verify folder exists
			If Not FSO.FolderExists(Folder) Then
				Set FSO = Nothing
				Call PublishError(7, "Folder does not exist: " & Folder)
				Exit Sub
			End If

			Dim Drive
			Dim AvailableSpace
			Drive = FSO.GetDriveName(Folder)
			AvailableSpace = FSO.GetDrive(Drive).AvailableSpace

			Set FSO = Nothing

			If AvailableSpace < DataLength Then
				Call PublishError(11, "Not enough free space available.")
				Exit Sub
			End If

		End If

		Dim lobjStream
		Dim lobjRs
		Dim lbinBytes

		' Don't save files that do not posess binary data
		If DataLength = 0 Then
			msg = "Failed to save file: " & FileName & ".  "
			msg = msg & " No data was found within the file (zero bytes)."
			msg = msg & " [Need help?  Contact Lewis Moten, lewis@moten.com, http://www.lewismoten.com]"
			On Error Goto 0
			Call Err.Raise(vbObjectError + 4, "Upload Without COM", msg)
		End If

		' Create magical objects from never never land
		Set lobjStream = Server.CreateObject("ADODB.Stream")

		' Let stream know we are working with binary data
		lobjStream.Type = adTypeBinary

		' Open stream
		Call lobjStream.Open()

		' Convert Integer Subtype Array to Byte Subtype Array
		lbinBytes = ASCII2Bytes(BinaryData)

		' Write binary data to stream
		Call lobjStream.Write(lbinBytes)

		' Save the binary data to file system
		'	Overwrites file if previously exists!
		On Error Resume Next
		Call lobjStream.SaveToFile(pstrFileName, adSaveCreateOverWrite)
		Select Case Err.number
			Case 0
				' Everything is ok.
				On Error Goto 0
			Case 3004
				msg = "Failed to save file as: " & pstrFileName & ".  "
				msg = msg & "[[[1]]] Make sure your IUSR_MACHINE account has "
				msg = msg & """write"" permission on the folder that you are "
				msg = msg & "uploading to.  [[[2]]] If your ISP has front "
				msg = msg & "page support installed, it may hose permissions."
				msg = msg & "  If this is the case, you may want to disable "
				msg = msg & "the front-page support for your production "
				msg = msg & "website or the subfolder you are uploading files"
				msg = msg & " to.  [[[3]]] Use small files for testing.  It "
				msg = msg & "could be that the large files are timing out.  "

				Call PublishError(2, msg)
			Case Else
				msg = "Failed to save file as: " & pstrFileName & "  "
				msg = msg & "Unexpected Error.  "
				msg = msg & "Error Number: " & Err.number
				msg = msg & " (0x" & Hex(Err.number) & ") "
				msg = msg & "Error Description: " & Err.Description & " "
				msg = msg & "Error Source: " & Err.Source

				Call PublishError(4, msg)
		End Select
		On Error Goto 0

		' Close the stream object
		Call lobjStream.Close()

		' Release objects
		Set lobjStream = Nothing

	End Sub
' ------------------------------------------------------------------------------
	Public Property Let FilePath(ByRef pstrPath)

		mstrPath = pstrPath

		' Parse File Ext
		If Not InStrRev(pstrPath, ".") = 0 Then
			FileExt = Mid(pstrPath, InStrRev(pstrPath, ".") + 1)
			FileExt = UCase(FileExt)
		End If

		' Parse File Name
		If InStrRev(pstrPath, "\") = 0 Then
			FileName = pstrPath
		Else
			FileName = Mid(pstrPath, InStrRev(pstrPath, "\") + 1)
		End If

		' Parse File Dir
		If Not InStrRev(pstrPath, "\") = 0 Then
			FileDir = Mid(pstrPath, 1, InStrRev(pstrPath, "\") - 1)
		End If

	End Property
' ------------------------------------------------------------------------------
	Public Property Get FilePath()
		FilePath = mstrPath
	End Property
' ------------------------------------------------------------------------------
	Private Function ASCII2Bytes(ByRef pbinBinaryData)

		Dim lobjRs
		Dim llngLength
		Dim lbinBuffer

		' get number of bytes
		llngLength = LenB(pbinBinaryData)

		Set lobjRs = Server.CreateObject("ADODB.Recordset")

		' create field in an empty recordset to hold binary data
		Call lobjRs.Fields.Append("BinaryData", adLongVarBinary, llngLength)

		' Open recordset
		Call lobjRs.Open()

		' Add a new record to recordset
		Call lobjRs.AddNew()

		' Populate field with binary data
		Call lobjRs.Fields("BinaryData").AppendChunk(pbinBinaryData & ChrB(0))

		' Update / Convert Binary Data
			' Although the data we have is binary - it has still been
			' formatted as 4 bytes to represent each byte.  When we
			' update the recordset, the Integer Subtype Array that we
			' passed into the Recordset will be converted into a
			' Byte Subtype Array
		Call lobjRs.Update()

		' Request binary data and save to stream
		lbinBuffer = lobjRs.Fields("BinaryData").GetChunk(llngLength)

		' Close recordset
		Call lobjRs.Close()

		' Release recordset from memory
		Set lobjRs = Nothing

		' Return Bytes
		ASCII2Bytes = lbinBuffer

	End Function
' ------------------------------------------------------------------------------
	Private Function Bytes2Unicode(ByRef pbinBytes)

		Dim lobjRs
		Dim llngLength
		Dim lstrBuffer

		llngLength = LenB(pbinBytes)
        
		Set lobjRs = Server.CreateObject("ADODB.Recordset")

		' Create field in an empty recordset to hold binary data
    	Call lobjRs.Fields.Append("BinaryData", adLongVarChar, llngLength)

    	' Open Recordset
    	Call lobjRs.Open()

    	' Add a new record to recordset
    	Call lobjRs.AddNew()

    	' Populate field with binary data
    	Call lobjRs.Fields("BinaryData").AppendChunk(pbinBytes)

    	' Update / Convert.
    		' Ensure bytes are proper subtype
    	Call lobjRs.Update()

    	' Request unicode value of binary data
    	lstrBuffer = lobjRs.Fields("BinaryData").Value

    	' Close recordset
    	Call lobjRs.Close()

    	' Release recordset from memory
    	Set lobjRs = Nothing

		' Return Unicode
		Bytes2Unicode = lstrBuffer

	End Function
' ------------------------------------------------------------------------------
	Private Sub Class_Initialize()

		ProductName = "Upload Without COM"
		ProductVersion = "3.0"
		ErrorSignature = "[Need help?  Contact Lewis Moten, lewis@moten.com, http://www.lewismoten.com]"

	End Sub
' ------------------------------------------------------------------------------
	Private Sub PublishError(number, message)
		' writes out error in a specific format.
		On Error Goto 0
		Call Err.Raise(vbObjectError + number, ProductName & " " & ProductVersion, message + ErrorSignature)
	End Sub
' ------------------------------------------------------------------------------
End Class
' ------------------------------------------------------------------------------
%>