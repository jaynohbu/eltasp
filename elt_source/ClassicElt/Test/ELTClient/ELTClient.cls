VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
  Persistable = 0  'NotPersistable
  DataBindingBehavior = 0  'vbNone
  DataSourceBehavior  = 0  'vbNone
  MTSTransactionMode  = 0  'NotAnMTSObject
END
Attribute VB_Name = "EltClient"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
Private Declare Function ShellExecute Lib "shell32.dll" Alias "ShellExecuteA" (ByVal hwnd As Long, ByVal lpszOp As String, ByVal lpszFile As String, ByVal lpszParams As String, ByVal lpszDir As String, ByVal FsShowCmd As Long) As Long
Private Declare Function GetDesktopWindow Lib "user32" () As Long
Const SW_SHOWNORMAL = 1
Private mlngDebugID As Long
Public Property Get DebugID() As Long
   DebugID = mlngDebugID
End Property

Public Sub ELT_Execute(ByVal cmd As String)
'Public Sub ELT_Execute(ByVal cmd As String, ByVal prm As String)
Shell (cmd)
'Dim Scr_hDC As Long
'Dim StartDoc As Long
   ' Scr_hDC = GetDesktopWindow()
    'StartDoc = ShellExecute(Scr_hDC, "Open", cmd, prm, "C:\", SW_SHOWNORMAL)
End Sub

Public Sub ELT_Test(X As String, Y As String)
MsgBox X & " " & Y
End Sub


