<Global.Microsoft.VisualBasic.CompilerServices.DesignerGenerated()> Partial Class frmGetMACadr
#Region "Windows Form Designer generated code "
	<System.Diagnostics.DebuggerNonUserCode()> Public Sub New()
		MyBase.New()
		'This call is required by the Windows Form Designer.
		InitializeComponent()
	End Sub
	'Form overrides dispose to clean up the component list.
	<System.Diagnostics.DebuggerNonUserCode()> Protected Overloads Overrides Sub Dispose(ByVal Disposing As Boolean)
		If Disposing Then
			If Not components Is Nothing Then
				components.Dispose()
			End If
		End If
		MyBase.Dispose(Disposing)
	End Sub
	'Required by the Windows Form Designer
	Private components As System.ComponentModel.IContainer
	Public ToolTip1 As System.Windows.Forms.ToolTip
	Public WithEvents cmdGetMAC2 As System.Windows.Forms.Button
	Public WithEvents cmdGetMAC As System.Windows.Forms.Button
	Public WithEvents txtMAClist As System.Windows.Forms.TextBox
	'NOTE: The following procedure is required by the Windows Form Designer
	'It can be modified using the Windows Form Designer.
	'Do not modify it using the code editor.
	<System.Diagnostics.DebuggerStepThrough()> Private Sub InitializeComponent()
		Dim resources As System.Resources.ResourceManager = New System.Resources.ResourceManager(GetType(frmGetMACadr))
		Me.components = New System.ComponentModel.Container()
		Me.ToolTip1 = New System.Windows.Forms.ToolTip(components)
		Me.cmdGetMAC2 = New System.Windows.Forms.Button
		Me.cmdGetMAC = New System.Windows.Forms.Button
		Me.txtMAClist = New System.Windows.Forms.TextBox
		Me.SuspendLayout()
		Me.ToolTip1.Active = True
		Me.Text = "GetMACadr"
		Me.ClientSize = New System.Drawing.Size(313, 193)
		Me.Location = New System.Drawing.Point(4, 23)
		Me.Icon = CType(resources.GetObject("frmGetMACadr.Icon"), System.Drawing.Icon)
		Me.StartPosition = System.Windows.Forms.FormStartPosition.WindowsDefaultLocation
		Me.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font
		Me.BackColor = System.Drawing.SystemColors.Control
		Me.FormBorderStyle = System.Windows.Forms.FormBorderStyle.Sizable
		Me.ControlBox = True
		Me.Enabled = True
		Me.KeyPreview = False
		Me.MaximizeBox = True
		Me.MinimizeBox = True
		Me.Cursor = System.Windows.Forms.Cursors.Default
		Me.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.ShowInTaskbar = True
		Me.HelpButton = False
		Me.WindowState = System.Windows.Forms.FormWindowState.Normal
		Me.Name = "frmGetMACadr"
		Me.cmdGetMAC2.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.cmdGetMAC2.Text = "Get MAC(s) via IfTable"
		Me.cmdGetMAC2.Size = New System.Drawing.Size(145, 25)
		Me.cmdGetMAC2.Location = New System.Drawing.Point(160, 160)
		Me.cmdGetMAC2.TabIndex = 2
		Me.cmdGetMAC2.BackColor = System.Drawing.SystemColors.Control
		Me.cmdGetMAC2.CausesValidation = True
		Me.cmdGetMAC2.Enabled = True
		Me.cmdGetMAC2.ForeColor = System.Drawing.SystemColors.ControlText
		Me.cmdGetMAC2.Cursor = System.Windows.Forms.Cursors.Default
		Me.cmdGetMAC2.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.cmdGetMAC2.TabStop = True
		Me.cmdGetMAC2.Name = "cmdGetMAC2"
		Me.cmdGetMAC.TextAlign = System.Drawing.ContentAlignment.MiddleCenter
		Me.cmdGetMAC.Text = "Get MAC(s) via AdapterInfo"
		Me.cmdGetMAC.Size = New System.Drawing.Size(145, 25)
		Me.cmdGetMAC.Location = New System.Drawing.Point(8, 160)
		Me.cmdGetMAC.TabIndex = 1
		Me.cmdGetMAC.BackColor = System.Drawing.SystemColors.Control
		Me.cmdGetMAC.CausesValidation = True
		Me.cmdGetMAC.Enabled = True
		Me.cmdGetMAC.ForeColor = System.Drawing.SystemColors.ControlText
		Me.cmdGetMAC.Cursor = System.Windows.Forms.Cursors.Default
		Me.cmdGetMAC.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.cmdGetMAC.TabStop = True
		Me.cmdGetMAC.Name = "cmdGetMAC"
		Me.txtMAClist.AutoSize = False
		Me.txtMAClist.Size = New System.Drawing.Size(297, 145)
		Me.txtMAClist.Location = New System.Drawing.Point(8, 8)
		Me.txtMAClist.MultiLine = True
		Me.txtMAClist.ScrollBars = System.Windows.Forms.ScrollBars.Both
		Me.txtMAClist.WordWrap = False
		Me.txtMAClist.TabIndex = 0
		Me.txtMAClist.AcceptsReturn = True
		Me.txtMAClist.TextAlign = System.Windows.Forms.HorizontalAlignment.Left
		Me.txtMAClist.BackColor = System.Drawing.SystemColors.Window
		Me.txtMAClist.CausesValidation = True
		Me.txtMAClist.Enabled = True
		Me.txtMAClist.ForeColor = System.Drawing.SystemColors.WindowText
		Me.txtMAClist.HideSelection = True
		Me.txtMAClist.ReadOnly = False
		Me.txtMAClist.Maxlength = 0
		Me.txtMAClist.Cursor = System.Windows.Forms.Cursors.IBeam
		Me.txtMAClist.RightToLeft = System.Windows.Forms.RightToLeft.No
		Me.txtMAClist.TabStop = True
		Me.txtMAClist.Visible = True
		Me.txtMAClist.BorderStyle = System.Windows.Forms.BorderStyle.Fixed3D
		Me.txtMAClist.Name = "txtMAClist"
		Me.Controls.Add(cmdGetMAC2)
		Me.Controls.Add(cmdGetMAC)
		Me.Controls.Add(txtMAClist)
		Me.ResumeLayout(False)
		Me.PerformLayout()
	End Sub
#End Region 
End Class