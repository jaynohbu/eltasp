Option Strict Off
Option Explicit On
Friend Class frmGetMACadr
	Inherits System.Windows.Forms.Form
	
	Private Sub cmdGetMAC_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdGetMAC.Click
		txtMAClist.Text = GetMACs_AdaptInfo()
	End Sub
	
	Private Sub cmdGetMAC2_Click(ByVal eventSender As System.Object, ByVal eventArgs As System.EventArgs) Handles cmdGetMAC2.Click
		txtMAClist.Text = GetMACs_IfTable()
	End Sub
End Class