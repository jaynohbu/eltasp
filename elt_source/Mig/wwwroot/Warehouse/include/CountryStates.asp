<%
Dim AllCountryCode(256),AllCountryDesc(256),countryIndex
Dim SQLContry,rsCountry
Set rsCountry = Server.CreateObject("ADODB.Recordset")
SQLContry= "select * from country_code where elt_account_number=" & elt_account_number & " order by country_name"
rsCountry.Open SQLContry, eltConn, , , adCmdText
countryIndex=0
Do While Not rsCountry.EOF
	AllCountryCode(countryIndex)=rsCountry("country_code")
	AllCountryDesc(countryIndex)=rsCountry("country_name")
	countryIndex=countryIndex+1
	rsCountry.MoveNext
Loop
rsCountry.Close
Set rsCountry=Nothing
'AllCountryCode(0)="KR"
'AllCountryDesc(0)="KOREA"
'AllCountryCode(1)="US"
'AllCountryDesc(1)="UNITED STATES"
'AllCountryCode(2)="CN"
'AllCountryDesc(2)="CHINA"
'AllCountryCode(2)="PH"
'AllCountryDesc(2)="PHILIPPINES"

' All States in US
Dim USState(50)
USState(0)="AK"
USState(1)="AL"
USState(2)="AR"
USState(3)="AZ"
USState(4)="CA"
USState(5)="CO"
USState(6)="CT"
USState(7)="DC"
USState(8)="DE"
USState(9)="FL"
USState(10)="GA"
USState(11)="HI"
USState(12)="IA"
USState(13)="ID"
USState(14)="IL"
USState(15)="IN"
USState(16)="KS"
USState(17)="KY"
USState(18)="LA"
USState(19)="MA"
USState(20)="MD"
USState(21)="ME"
USState(22)="MI"
USState(23)="MN"
USState(24)="MO"
USState(25)="MS"
USState(26)="MT"
USState(27)="NC"
USState(28)="ND"
USState(29)="NE"
USState(30)="NH"
USState(31)="NJ"
USState(32)="NM"
USState(33)="NV"
USState(34)="NY"
USState(35)="OH"
USState(36)="OK"
USState(37)="OR"
USState(38)="PA"
USState(39)="RI"
USState(40)="SC"
USState(41)="SD"
USState(42)="TN"
USState(43)="TX"
USState(44)="UT"
USState(45)="VA"
USState(46)="VT"
USState(47)="WA"
USState(48)="WI"
USState(49)="WV"
USState(50)="WY"
%>