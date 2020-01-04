<!--
<object id="EltClient" classid="CLSID:B38256C8-D8AE-42FF-8B14-B6FAB132E440" codebase="ELTAuth.CAB#version=2,2,0,0">
    <param name="copyright" value="http://www.freighteasy.net">
</object>
-->

<script type="text/vbscript">

</script>
<script type="text/javascript">

    function checkPrintStop( startCheck, CheckNo ){
        var tmpUrl = "print_check_OK.asp?startCheckNo="+ startCheck + "&endCheckNo=" + CheckNo;
        var qS = showModalDialog("print_check_dialog.asp?"+tmpUrl ,"","dialogWidth:700px; dialogHeight:230px; help:no; status:no; scroll:no;center:yes");
        if (qS == "" )
            qS = -1;
        var y = new Number(qS);
        return y;
    }

    function checkPrintStopSingle( CheckNo ){
        var tmpUrl = "print_single_check_OK.asp?CheckNo=" + CheckNo;
        var qS = showModalDialog("print_check_dialog.asp?" + tmpUrl, "", "dialogWidth:700px; dialogHeight:230px; help:no; status:no; scroll:no;center:yes");
        if (qS == "" )
            qS = -1;
        //checkPrintStopSingle = cLng(qS)
        var y = new Number(qS);
        return y;
    }
        function ToMoney(Money) {
       
        strMoney = Money.toString();
        var Dollar = "";
        var Cent = "00";
        var intCent = 0;
        if (strMoney.indexOf(".") > 0) {
            var arrMoney = strMoney.split(".");
            Dollar = arrMoney[0];
            var intCent = Math.round(parseFloat(arrMoney[1]));
            Cent = intCent.toString();

        } else
            Dollar = strMoney;

        return convert_number(Dollar) + " and " + Cent + "/100";
    }
function convert_number(number) {
    if ((number < 0) || (number > 999999999)) {
        return "Number is out of range";
    }
    var Gn = Math.floor(number / 10000000);  /* Crore */
    number -= Gn * 10000000;
    var kn = Math.floor(number / 100000);     /* lakhs */
    number -= kn * 100000;
    var Hn = Math.floor(number / 1000);      /* thousand */
    number -= Hn * 1000;
    var Dn = Math.floor(number / 100);       /* Tens (deca) */
    number = number % 100;               /* Ones */
    var tn = Math.floor(number / 10);
    var one = Math.floor(number % 10);
    var res = "";

    if (Gn > 0) {
        res += (convert_number(Gn) + " Crore");
    }
    if (kn > 0) {
        res += (((res == "") ? "" : " ") +
            convert_number(kn) + " Lakhs");
    }
    if (Hn > 0) {
        res += (((res == "") ? "" : " ") +
            convert_number(Hn) + " Thousand");
    }

    if (Dn) {
        res += (((res == "") ? "" : " ") +
            convert_number(Dn) + " hundred");
    }


    var ones = Array("", "One", "Two", "Three", "Four", "Five", "Six", "Seven", "Eight", "Nine", "Ten", "Eleven", "Twelve", "Thirteen", "Fourteen", "Fifteen", "Sixteen", "Seventeen", "Eightteen", "Nineteen");
    var tens = Array("", "", "Twenty", "Thirty", "Forty", "Fifty", "Sixty", "Seventy", "Eigthy", "Ninety");

    if (tn > 0 || one > 0) {
        if (!(res == "")) {
            res += " ";
        }
        if (tn < 2) {
            res += ones[tn * 10 + one];
        }
        else {

            res += tens[tn];
            if (one > 0) {
                res += ("-" + ones[one]);
            }
        }
    }

    if (res == "") {
        res = "zero";
    }
    return res;

}
</script>
<script type="text/vbscript">
'Sub PrintCheck(CheckNo,Vendor,CheckAmt,Money,CheckDate,ClientOS,vPrintPort,vMemo,aItem,NoItem)

'Dim Line(100),VendorInfo(4)
'pos=Instr(Vendor,chr(10))
'i=0

'For iii = 1 To 45
'	Line(iii) = ""
'Next

'do While pos>0 And i<4
'	VendorInfo(i)=Left(Vendor,pos-2)
'	Vendor=Mid(Vendor,pos+1,2000)
'	pos=Instr(Vendor,chr(10))
'	i=i+1
'Loop

'VendorInfo(i)=Vendor
'	Set fso = CreateObject("Scripting.FileSystemObject")
'	If Not fso.FolderExists("C:\TEMP") Then
'		Set f = fso.CreateFolder("C:\TEMP")
'	End If
'	If Not fso.FolderExists("C:\TEMP\Eltdata") Then
'		Set f = fso.CreateFolder("C:\TEMP\Eltdata")
'	End If
'	Set MyFile = fso.CreateTextFile("C:\TEMP\EltData\check" & CheckNo & ".txt", True)
'	MyFile.WriteLine(chr(27) & chr(67) & chr(42))
'	pTop=6
'	pLeft=0
'	for i=1 to pTop
'		MyFile.WriteLine("")
'	next 
'	Line(0)=Space(4) & Money & "  " & "Dollars"
'	Line(1)=""
'	Line(2)=""
'	Line(3)=Space(48) & CheckDate 
'	
'	Line(3)=Line(3) & Space(63-Len(Line(3))) & FormatCurrency(CheckAmt)
'	
'	Line(4)=""
'	for i=0 to 3
'		Line(5+i)=Space(8) & VendorInfo(i)
'	Next
'	Line(9)=""
'	Line(10)=Space(0) & Mid(vMemo,1,50)
'	Line(11)=""
'	Line(12)=""
'	Line(13)=""
'	Line(14)=""
'	Line(15)=""
'	Line(16)=""
'	Line(17)=""

'	for i=1 to NoItem
'		Line(17+i)=space(2) & aItem(i)
'	next

'	ClientOS="<%= ClientOS %>"
'	If ClientOS="NT" then
'		tLine=25
'	else
'		tLine=26
'	end if

'	For i=0 to tLine
'		MyFile.WriteLine(Line(i))
'	next

'	MyFile.Close
'	Set fso=Nothing

'	If vPrintPort = "" Then vPrintPort = "LPT1"

'	DIM fileName
'	fileName = "C:\TEMP\EltData\check" & CheckNo & ".txt"

'	DIM tmpPort
'	On Error Resume Next:
'	tmpPort = TRIM(UCASE(vPrintPort))

'	if tmpPort = "LPT1" or tmpPort = "LPT2" or tmpPort = "LPT3" or tmpPort = "LPT4" or tmpPort = "LPT5" _ 
'	or tmpPort = "LPT6" or tmpPort = "LPT7" or tmpPort = "LPT8" then
'		Call ELTClient.ELTPrintForm(FileName,vPrintPort)
'	else
'		Call ELTClient.ELTPrintFormWithNetwork(FileName,vPrintPort)
'	end if

'	Sleep 2
'	// LPT9 port init
'	Call ELTClient.ELTPrintPortInit()

'end Sub

Sub Sleep(tmpSeconds)
    Dim dtmOne,dtmTwo
    dtmOne = Now()
    While DateDiff("s",dtmOne,dtmTwo) < tmpSeconds
	    dtmTwo = Now()
    Wend
End Sub

-->
</script>