VERSION 5.00
Begin VB.Form frmAbout 
   Caption         =   "About"
   ClientHeight    =   1005
   ClientLeft      =   60
   ClientTop       =   450
   ClientWidth     =   5310
   Icon            =   "frmAbout.frx":0000
   LinkTopic       =   "Form1"
   MaxButton       =   0   'False
   MinButton       =   0   'False
   ScaleHeight     =   1005
   ScaleWidth      =   5310
   StartUpPosition =   2  'CenterScreen
   Begin VB.CommandButton Command1 
      Caption         =   "OK"
      Default         =   -1  'True
      Height          =   375
      Left            =   4200
      TabIndex        =   2
      Top             =   120
      Width           =   975
   End
   Begin VB.Image Image1 
      Height          =   675
      Left            =   120
      Picture         =   "frmAbout.frx":030A
      Stretch         =   -1  'True
      Top             =   120
      Width           =   675
   End
   Begin VB.Label Label2 
      Caption         =   "Copyright (C) 2006, E-LOGISTICS TECHNOLOGY, INC."
      Height          =   255
      Left            =   960
      TabIndex        =   1
      Top             =   600
      Width           =   4335
   End
   Begin VB.Label Label1 
      Caption         =   "FreightEasyNet Control, Version 1.0"
      Height          =   255
      Left            =   960
      TabIndex        =   0
      Top             =   240
      Width           =   2775
   End
End
Attribute VB_Name = "frmAbout"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
Private Sub Command1_Click()
Unload Me
End Sub
