VERSION 5.00
Begin VB.UserControl ELTAuthMain 
   ClientHeight    =   3600
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   InvisibleAtRuntime=   -1  'True
   ScaleHeight     =   3600
   ScaleWidth      =   4800
   Windowless      =   -1  'True
End
Attribute VB_Name = "ELTAuthMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Option Explicit
Dim sCopyRight
Public Function ELTMacAddress()
    ELTMacAddress = GetMAC_Address()
End Function

Public Function ELTIPAddress()
    ELTIPAddress = GetIP_Address()
End Function

Public Function EltDomainName()
    EltDomainName = GetDomainName("DOMAIN")
End Function

Public Function ELTComputerName()
    ELTComputerName = GetComputerName()
End Function

Public Function ELTUserName()
    ELTUserName = GetUserName()
End Function

Public Sub ELTPrintForm(ByVal strFileName As String, ByVal strPortName As String)
    sysPrintForm strFileName, strPortName
End Sub

Public Sub ELTPrintForm_Debug(ByVal strFileName As String, ByVal strPortName As String)
    MsgBox strFileName & " " & strPortName
End Sub

Public Sub ELTShowAbout()
    frmAbout.Show vbModal
End Sub

Public Function showCopyRight()
    showCopyRight = sCopyRight
End Function

Private Sub UserControl_ReadProperties(PropBag As PropertyBag)
    sCopyRight = PropBag.ReadProperty("CopyRight", "")
End Sub
