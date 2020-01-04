<%
On Error Resume Next:

Const HKEY_CURRENT_USER = &H80000001

strComputer = "."
Set objReg=GetObject("winmgmts:\\" & strComputer & "\root\default:StdRegProv")
strKeyPath = "Software\Microsoft\Windows\CurrentVersion\Internet Settings\" _
    & "ZoneMap\Domains\microsoft.com"

objReg.CreateKey HKEY_CURRENT_USER, strKeyPath

strValueName = "http"
dwValue = 2

objReg.SetDWORDValue HKEY_CURRENT_USER, strKeyPath, strValueName, dwValue
%>
