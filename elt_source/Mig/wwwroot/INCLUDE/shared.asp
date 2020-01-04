<SCRIPT LANGUAGE="vbscript">
<!---
Function ToMoney(Money) 
Dim dd
Dim dWord3(10)
Dim dWord21(100)
Dim dWord(2, 4)
Dim dTemp(4)
Dim dScale(3)
dScale(0) = ""
dScale(1) = "thousand"
dScale(2) = "million"
dScale(3) = "billion"
dWord3(0) = "zero"
dWord3(1) = "one"
dWord3(2) = "two"
dWord3(3) = "three"
dWord3(4) = "four"
dWord3(5) = "five"
dWord3(6) = "six"
dWord3(7) = "seven"
dWord3(8) = "eight"
dWord3(9) = "nine"
dWord21(0) = ""
dWord21(1) = "one"
dWord21(2) = "two"
dWord21(3) = "three"
dWord21(4) = "four"
dWord21(5) = "five"
dWord21(6) = "six"
dWord21(7) = "seven"
dWord21(8) = "eight"
dWord21(9) = "nine"
dWord21(10) = "ten"
dWord21(11) = "eleven"
dWord21(12) = "twelve"
dWord21(13) = "thirteen"
dWord21(14) = "forteen"
dWord21(15) = "fifteen"
dWord21(16) = "sixteen"
dWord21(17) = "seventeen"
dWord21(18) = "eighteen"
dWord21(19) = "nineteen"
dWord21(20) = "twenty"
dWord21(21) = "twenty-one"
dWord21(22) = "twenty-two"
dWord21(23) = "twenty-three"
dWord21(24) = "twenty-four"
dWord21(25) = "twenty-five"
dWord21(26) = "twenty-six"
dWord21(27) = "twenty-seven"
dWord21(28) = "twenty-eight"
dWord21(29) = "twenty-nine"
dWord21(30) = "thirty"
dWord21(31) = "thirty-one"
dWord21(32) = "thirty-two"
dWord21(33) = "thirty-three"
dWord21(34) = "thirty-four"
dWord21(35) = "thirty-five"
dWord21(36) = "thirty-six"
dWord21(37) = "thirty-seven"
dWord21(38) = "thirty-eight"
dWord21(39) = "thirty-nine"
dWord21(40) = "forty"
dWord21(41) = "forty-one"
dWord21(42) = "forty-two"
dWord21(43) = "forty-three"
dWord21(44) = "forty-four"
dWord21(45) = "forty-five"
dWord21(46) = "forty-six"
dWord21(47) = "forty-seven"
dWord21(48) = "forty-eight"
dWord21(49) = "forty-nine"
dWord21(50) = "fifty"
dWord21(51) = "fifty-one"
dWord21(52) = "fifty-two"
dWord21(53) = "fifty-three"
dWord21(54) = "fifty-four"
dWord21(55) = "fifty-five"
dWord21(56) = "fifty-six"
dWord21(57) = "fifty-seven"
dWord21(58) = "fifty-eight"
dWord21(59) = "fifty-nine"
dWord21(60) = "sixty"
dWord21(61) = "sixty-one"
dWord21(62) = "sixty-two"
dWord21(63) = "sixty-three"
dWord21(64) = "sixty-four"
dWord21(65) = "sixty-five"
dWord21(66) = "sixty-six"
dWord21(67) = "sixty-seven"
dWord21(68) = "sixty-eight"
dWord21(69) = "sixty-nine"
dWord21(70) = "seventy"
dWord21(71) = "seventy-one"
dWord21(72) = "seventy-two"
dWord21(73) = "seventy-three"
dWord21(74) = "seventy-four"
dWord21(75) = "seventy-five"
dWord21(76) = "seventy-six"
dWord21(77) = "seventy-seven"
dWord21(78) = "seventy-eight"
dWord21(79) = "seventy-nine"
dWord21(80) = "eighty"
dWord21(81) = "eighty-one"
dWord21(82) = "eighty-two"
dWord21(83) = "eighty-three"
dWord21(84) = "eighty-four"
dWord21(85) = "eighty-five"
dWord21(86) = "eighty-six"
dWord21(87) = "eighty-seven"
dWord21(88) = "eighty-eight"
dWord21(89) = "eighty-nine"
dWord21(90) = "ninety"
dWord21(91) = "ninety-one"
dWord21(92) = "ninety-two"
dWord21(93) = "ninety-three"
dWord21(94) = "ninety-four"
dWord21(95) = "ninety-five"
dWord21(96) = "ninety-six"
dWord21(97) = "ninety-seven"
dWord21(98) = "ninety-eight"
dWord21(99) = "ninety-nine"
'dd=document.form1.txtAmount.Value
dd=Money
if dd="" then dd=0

dd = CStr(FormatCurrency(dd))
dd = Mid(dd, 2, 100)
Dim pos, i
i = 0
pos = 0
pos = InStr(dd, ".")
Cent = Mid(dd, pos + 1, 2) & "/100"
dd = Mid(dd, 1, pos - 1)
If dd = 0 Then
    dWord21(0) = "Zero"
Else
    dWord21(0) = ""
End If
pos = InStr(dd, ",")
Do While pos > 0 And i < 4
    dTemp(i) = CInt(Mid(dd, 1, pos - 1))
    If Len(dTemp(i)) = 3 Then
        x = Mid(dTemp(i), 1, 1)
        y = Mid(dTemp(i), 2, 2)
        dWord(0, i) = dWord3(x) & " " & "hundred"
        dWord(1, i) = dWord21(y)
    Else
        dWord(0, i) = ""
        dWord(1, i) = dWord21(dTemp(i))
    End If
    dd = Mid(dd, pos + 1, 100)
    i = i + 1
    pos = InStr(dd, ",")
Loop
dTemp(i) = CInt(dd)
If Len(dTemp(i)) = 3 Then
    x = Mid(dTemp(i), 1, 1)
    y = Mid(dTemp(i), 2, 2)
    dWord(0, i) = dWord3(x) & " " & "hundred"
    dWord(1, i) = dWord21(y)
Else
    dWord(0, i) = ""
    dWord(1, i) = dWord21(dTemp(i))
End If

Amount = ""
For j = 0 To i
    If dWord(0, j) = "" And dWord(1, j) = "" Then dScale(i - j) = ""
    Amount = Amount & " " & dWord(0, j) & " " & dWord(1, j) & " " & dScale(i - j)
Next
Amount = Amount & " and " & Cent
Amount=Trim(Amount)
'MsgBox UCase(Amount)
A1=UCase(Mid(Amount,1,1))
Amount=Mid(Amount,2,200)
Amount = A1 & Amount
'Document.Write(Amount)
ToMoney=Amount

End Function

Sub PrintCheck(CheckNo,Vendor,CheckAmt,Money,CheckDate,ClientOS,vPrintPort)
Dim Line(45),VendorInfo(4)
pos=Instr(Vendor,chr(10))
i=0
do While pos>0 And i<4
	VendorInfo(i)=Left(Vendor,pos-2)
	Vendor=Mid(Vendor,pos+1,2000)
	pos=Instr(Vendor,chr(10))
	i=i+1
loop
VendorInfo(i)=Vendor
	Set fso = CreateObject("Scripting.FileSystemObject")
	If Not fso.FolderExists("C:\TEMP") Then
		Set f = fso.CreateFolder("C:\TEMP")
	End If
	If Not fso.FolderExists("C:\TEMP\EltData") Then
		Set f = fso.CreateFolder("C:\TEMP\EltData")
	End If
	Set MyFile = fso.CreateTextFile("c:\TEMP\EltData\check" & CheckNo & ".txt", True)
	MyFile.WriteLine(chr(27) & chr(67) & chr(42))
	pTop=7
	pLeft=2
	for i=1 to pTop
		MyFile.WriteLine("")
	next 
	'Line(1)=Space(8) & CheckNo
	'Line(1)=Line(1) & Space(50-Len(Line(1))) & CheckDate
	'Line(1)=Line(1) & Space(66-Len(Line(1))) & FormatCurrency(CheckAmt)
	'Line(1)=Space(pLeft) & Line(1)
	Line(1)=Space(2) & Money & "  " & "Dollars"
	Line(1)=Line(1) & Space(53-Len(Line(1))) & CheckDate 
	Line(1)=Line(1) & Space(72-Len(Line(1))) & FormatCurrency(CheckAmt)
	Line(2)=""
	for i=0 to 3
		Line(3+i)=Space(10) & VendorInfo(i)
	next
	For i=1 to 6
		MyFile.WriteLine(Line(i))
	next
	MyFile.Close
	Set fso=Nothing
	Set MyClient = CreateObject("ELTSoft.ELTClient")
	if ClientOS="NT" then
		Call MyClient.ELT_Execute("print /d:" & vPrintPort & " c:\TEMP\EltData\check" & CheckNo & ".txt")
	else
		Call MyClient.ELT_Execute("c:\command.com /c copy c:\TEMP\EltData\check" & CheckNo & ".txt" & vPrintPort)
	end if
	Set MyClient=Nothing
end Sub
-->
</script>