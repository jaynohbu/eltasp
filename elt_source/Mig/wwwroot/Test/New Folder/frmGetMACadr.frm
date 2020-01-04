VERSION 5.00
Begin VB.Form frmGetMACadr 
   Caption         =   "GetMACadr"
   ClientHeight    =   2895
   ClientLeft      =   60
   ClientTop       =   345
   ClientWidth     =   4695
   Icon            =   "frmGetMACadr.frx":0000
   LinkTopic       =   "Form1"
   ScaleHeight     =   2895
   ScaleWidth      =   4695
   StartUpPosition =   3  'Windows-Standard
   Begin VB.CommandButton cmdGetMAC2 
      Caption         =   "Get MAC(s) via IfTable"
      Height          =   375
      Left            =   2400
      TabIndex        =   2
      Top             =   2400
      Width           =   2175
   End
   Begin VB.CommandButton cmdGetMAC 
      Caption         =   "Get MAC(s) via AdapterInfo"
      Height          =   375
      Left            =   120
      TabIndex        =   1
      Top             =   2400
      Width           =   2175
   End
   Begin VB.TextBox txtMAClist 
      Height          =   2175
      Left            =   120
      MultiLine       =   -1  'True
      ScrollBars      =   3  'Beides
      TabIndex        =   0
      Top             =   120
      Width           =   4455
   End
End
Attribute VB_Name = "frmGetMACadr"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Option Explicit

Private Sub cmdGetMAC_Click()
    txtMAClist.Text = GetMACs_AdaptInfo()
End Sub

Private Sub cmdGetMAC2_Click()
    txtMAClist.Text = GetMACs_IfTable()
End Sub
