<%
' ------------------------------------------------------------------------------
Class clsProgress
' ------------------------------------------------------------------------------
	Public TotalBytes		' Number of bytes client sent to server
	Public BytesReceived	' Number of bytes received by server
	Public UploadStarted	' Time on server when upload started
	Public UploadCompleted	' Time on server when upload was completed
	Public LastActive		' Time on server when upload was last active

	Private FileName		' Name of temporary file holding progress information
	Private FSO				' File System Object
	Private Enabled			' Determines if progress class is enabled
' ------------------------------------------------------------------------------
	Public Function Load()

		' don't do anything if disabled
		If Not Enabled Then Exit Function

		Dim Data ' raw data about progress
		Dim Lines ' Array of lines within data
		Dim Line ' Individual line of name/value pair
		Dim Pair ' Property array containing name and value

		' Initialize default values
		TotalBytes = 0
		BytesReceived = 0
		UploadStarted = ""
		LastActive = ""
		UploadCompleted = ""

		' Retrieve information
		Data = ProgressData

		' If information is empty
		If Data = "" Then

			' Instruct caller that method failed
			Load = False
			Exit Function

		End If

		' Load session data, split into an array by
		' finding carriage returns
		Lines = Split(Data, vbCrLf)

		' Loop through each line
		For Each Line In Lines

			' parse loaded session
			' name=value
			Pair = Split(Line, "=", 2)

			' If pair has 2 indexes
			If UBound(Pair, 1) = 1 Then

				' Determine action based on first index
				' (attribute name)
				Select Case Pair(0)
					Case "TotalBytes"
						TotalBytes = CLng(Pair(1))
					Case "BytesReceived"
						BytesReceived = CLng(Pair(1))
					Case "UploadStarted"
						If IsDate(Pair(1)) Then
							UploadStarted = CDate(Pair(1))
						End If
					Case "LastActive"
						If IsDate(Pair(1)) Then
							LastActive = CDate(Pair(1))
						End If
					Case "UploadCompleted"
						If IsDate(Pair(1)) Then
							UploadCompleted = CDate(Pair(1))
						End If
				End Select
			End If
		Next

		' Return success
		Load = True

	End Function
' ------------------------------------------------------------------------------
	Public Sub Save()

		' don't do anything if disabled
		If Not Enabled Then Exit Sub

		Dim Data

		' save data into Info string
		Data = Data & "TotalBytes=" & TotalBytes & vbCrLf
		Data = Data & "BytesReceived=" & BytesReceived & vbCrLf
		Data = Data & "UploadStarted=" & UploadStarted & vbCrLf
		Data = Data & "LastActive=" & LastActive & vbCrLf
		Data = Data & "UploadCompleted=" & UploadCompleted & vbCrLf

		' save the information
		ProgressData = Data

	End Sub
' ------------------------------------------------------------------------------
	Private Sub Class_Initialize()

		' Declare FSO Constants
		Const WindowsFolder = 0
		Const SystemFolder = 1
		Const TemporaryFolder = 2

		Dim Folder

		' Only enable class if session ID was received
		Enabled = Not Request.QueryString("Session") = ""

		' Are we allowed to interact with FileSystemObject?
		If Not (FileSystemObjectEnabled Or FileSystemObjectEnabled = "") Then
			Enabled = False
		End If

		' don't do anything if disabled
		If Not Enabled Then Exit Sub

		' Instantiate File System Objec
		Set FSO = Server.CreateObject("Scripting.FileSystemObject")

		' Build path to information file in temporary folder
		Folder = FSO.GetSpecialFolder(TemporaryFolder).Path

		FileName ="AspUpload_" & Request.QueryString("Session") & ".tmp"

		FileName = Folder & "\" & FileName

	End Sub
' ------------------------------------------------------------------------------
	Private Sub Class_Terminate()

		' don't do anything if disabled
		If Not Enabled Then Exit Sub

		' Garbage Collection
		Set FSO = Nothing

	End Sub
' ------------------------------------------------------------------------------
	Private Property Get ProgressData()

		' don't do anything if disabled
		If Not Enabled Then Exit Property

		Dim File

		' If file does not yet exist, don't do anything
		If Not FSO.FileExists(FileName) Then Exit Property

		' Get the file
		Set File = FSO.OpenTextFile(FileName)

		' if the file has information
		If Not File.AtEndOfStream  Then

			' Read all the information
			ProgressData = File.ReadAll

		End If

		' Close the connection to the file
		File.Close

		' Garbage collection
		Set File = Nothing

	End Property
' ------------------------------------------------------------------------------
	Private Property Let ProgressData(ByRef information)

		' don't do anything if disabled
		If Not Enabled Then Exit Property

		' Declare Constants
		Const ForReading = 1
		Const ForWriting = 2
		Const ForAppending = 8

		Dim File

		' Open the text file
		'	* Create if it doesn't exist
		'	* Open for writing
		Set File = FSO.OpenTextFile(FileName, ForWriting, True)

		' Write the information to the file
		Call File.Write(information)

		' Close the connection to the file
		File.Close

		' Garbage collection
		Set File = Nothing

	End Property
' ------------------------------------------------------------------------------
End Class
' ------------------------------------------------------------------------------
%>