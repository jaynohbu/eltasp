Attribute VB_Name = "ClientModule"
Option Explicit
Public gdatServerStarted As Date

Sub Main()
   ' Code to be executed when the component starts,
   '   in response to the first object request.
   gdatServerStarted = Now
   Debug.Print "Executing Sub Main"
End Sub

' Function to provide unique identifiers for objects.
Public Function GetDebugID() As Long
   Static lngDebugID As Long
   lngDebugID = lngDebugID + 1
   GetDebugID = lngDebugID
End Function


