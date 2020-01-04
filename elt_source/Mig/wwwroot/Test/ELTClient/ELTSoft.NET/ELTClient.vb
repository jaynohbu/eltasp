Option Strict Off
Option Explicit On
<System.Runtime.InteropServices.ProgId("EltClient_NET.EltClient")> Public Class EltClient
	Private Declare Function ShellExecute Lib "shell32.dll"  Alias "ShellExecuteA"(ByVal hwnd As Integer, ByVal lpszOp As String, ByVal lpszFile As String, ByVal lpszParams As String, ByVal lpszDir As String, ByVal FsShowCmd As Integer) As Integer
	Private Declare Function GetDesktopWindow Lib "user32" () As Integer
	Const SW_SHOWNORMAL As Short = 1
	Private mlngDebugID As Integer
	Public ReadOnly Property DebugID() As Integer
		Get
			DebugID = mlngDebugID
		End Get
	End Property
	
	Public Sub ELT_Execute(ByVal cmd As String)
        Shell(cmd)
    End Sub
	
	Public Sub ELT_Test(ByRef X As String, ByRef Y As String)
		MsgBox(X & " " & Y)
	End Sub
End Class