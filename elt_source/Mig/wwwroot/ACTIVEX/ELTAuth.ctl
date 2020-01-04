VERSION 5.00
Begin VB.UserControl ELTAuthMain 
   ClientHeight    =   3600
   ClientLeft      =   0
   ClientTop       =   0
   ClientWidth     =   4800
   ScaleHeight     =   90
   ScaleMode       =   0  'User
   ScaleWidth      =   4800
End
Attribute VB_Name = "ELTAuthMain"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = True
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = True
Public Function ELTMacAddress()
    MacAddress = GetMAC_Address()
End Function

Public Function ELTIPAddress()
    IPAddress = GetIP_Address()
End Function

Public Function EltDomainName()
    DomainName = GetDomainName("DOMAIN")
End Function

Public Function ELTComputerName()
    ComputerName = GetComputerName()
End Function

Public Function ELTUserName()
    UserName = GetUserName()
End Function

Public Sub ELTPrintForm(strFileName As String, strPortName As String)
    sysPrintForm strFileName, strPortName
End Sub

Public Sub ELTPrintForm_Debug(strFileName As String, strPortName As String)
    MsgBox strFileName & " " & strPortName
End Sub

Public Sub ELTShowAbout()
    frmAbout.Show vbModal
End Sub

