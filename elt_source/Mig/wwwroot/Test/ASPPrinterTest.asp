<%@Language=VBScript%>


<HTML>
<HEAD>
<META Name="GENERATOR" Content="Microsoft Visual Studio 6.0">
<LINK rel="stylesheet" Type="text/css" href="styleshtm.css">
</HEAD>
<BODY TOPMARGIN=15 Class=TR1>
<STYLE>
<!--
TABLE
{BORDER-RIGHT: thin; BORDER-TOP: thin;FONT-WEIGHT: normal; FONT-SIZE: 10pt; BORDER-LEFT: thin; COLOR: black; BORDER-BOTTOM: thin; FONT-FAMILY: Verdana, Tahoma}
.Header
{FONT-WEIGHT: bold; FONT-SIZE: 8pt; COLOR: white; FONT-FAMILY: Verdana, Tahoma; BACKGROUND-COLOR: steelblue}
.TR1
{FONT-SIZE: 8pt; FONT-FAMILY: Verdana, Tahoma; BACKGROUND-COLOR: ivory}
.TR2
{BORDER-RIGHT: thin; BORDER-TOP: thin; PADDING-LEFT: 5pt; FONT-SIZE: 8pt; BORDER-LEFT: thin; BORDER-BOTTOM: thin; FONT-FAMILY: Verdana, Tahoma; BACKGROUND-COLOR: #dcdcd9}
.TR3{FONT-SIZE: 8pt; FONT-FAMILY: Verdana, Tahoma; BACKGROUND-COLOR: moccasin}
TEXTAREA
{FONT-SIZE: 10pt; COLOR: darkred; FONT-FAMILY: Verdana, Tahoma}
.border
{BORDER-RIGHT: thin ridge; BORDER-TOP: thin ridge; BORDER-LEFT: thin ridge; BORDER-BOTTOM: thin ridge}
.Title1
{FONT-WEIGHT: bold; FONT-SIZE: 14pt; PADDING-BOTTOM: 5pt; COLOR: yellow; PADDING-TOP: 5pt; FONT-FAMILY: Verdana, Tahoma; BACKGROUND-COLOR: #7f0001; TEXT-ALIGN: center}
.blueButton
{BORDER-RIGHT: thin outset; BORDER-TOP: thin outset; FONT-WEIGHT: bold; FONT-SIZE: 8pt; MARGIN-BOTTOM: 4pt; BORDER-LEFT: thin outset; WIDTH: 250pt; CURSOR: hand; COLOR: white; LINE-HEIGHT: 15pt; BORDER-BOTTOM: thin outset; BACKGROUND-COLOR: steelblue}
.Title2
{FONT-WEIGHT: bold; FONT-SIZE: 12pt; PADDING-BOTTOM: 2pt; COLOR: white; PADDING-TOP: 2pt; FONT-FAMILY: Verdana, Tahoma; BACKGROUND-COLOR: steelblue}
H5
{BORDER-RIGHT: thin groove; PADDING-RIGHT: 5px; BORDER-TOP: thin groove; PADDING-LEFT: 5px; FONT-WEIGHT: bold; FONT-SIZE: 8pt; PADDING-BOTTOM: 2px; BORDER-LEFT: thin groove; LINE-HEIGHT: 14pt; PADDING-TOP: 2px; BORDER-BOTTOM: thin groove; FONT-FAMILY: Verdana, Tahoma; BACKGROUND-COLOR: #dcdcdc; TEXT-ALIGN: left}
-->
</STYLE>
<OBJECT ID="ASPPrinter"
CLASSID="CLSID:48CB850F-41FF-4EE6-B87D-FB9EC26D193F"
CODEBASE="ASPPrinter.CAB#version=2,1,0,0">
</OBJECT>
	<CENTER>
	<P Class=Title1>VBGold ASP Printer COM Examples</P>
	


		<Form Name=Form1 Action="Print.asp" Method=Post>
		<P Class=Title2>Print The Output Of An ASP Page On The Client Machine Using The Document's HTML Source Code</P>

		<H5><img src="http://www.vbgold.com/images/ASPPrinterIcon.gif"> This example will show you, using just a single line of code!!...and without displaying any Windows Print Dialogs, how you can print on the client machine, the HTML output (the html page) from an ASP page using the HTML source code of the document viewed in the client's browser. The document is printed exactly as you see it in your web browser (WYSIWYG - What You See Is What You Get)<BR>
		The printing will apply all the formatting (fonts, colors, backgrounds, margins, etc.) specified in the HTML code that will be passed to the ASP Printer object. Also, any images that are referenced in the HTML code will be printed as they appear on the page when viewed in the web browser.<br>
		Remember however that the output of the HTML code is printed on the client machine. Therefore, the image paths (urls) must be the fully-qualified paths (not relative paths) of the files on the web server. For example, a valid image url is "http://www.vbgold.com/images/ASPPrinterIcon.gif", not "images/ASPPrinterIcon.gif".<BR><BR>
		<font color=red>Note that this page will automatically download and install the component on the client machine (if it was not previously installed). This requires that you have the ASPPrinter.CAB file in the same virtual directory of you ASP page on the web server. Also, the IE security settings on the client must be adjusted to enable the downloading, initialization and scripting of ActiveX controls (the default setting is "disabled" for some of these options)!</font>
		</H5>
		<%for i=1 to 24
			Response.Write "<img src='http://www.vbgold.com/images/ASPPrinterIcon.gif'>&nbsp;"
		next%>
		<br>

		<table border=1 cellspacing=0 cellpadding=5 class=border id=TableToPrint>
		<tr>
		<td class=Header>Customer ID</td>
		<td class=Header>Company Name</td>
		<td class=Header>Contact Name</td>
		<td class=Header>Contact Title</td>
		<td class=Header>Address</td>
		<td class=Header>City</td>
		<td class=Header>Region</td>
		</tr>
		<tr class=TR1><td>ALFKI</font></td><td>Alfreds Futterkiste</font></td><td>Maria Anders</font></td><td>Sales Representative</font></td><td>Obere Str. 57</font></td><td>Berlin</font></td><td>&nbsp;</font></td></tr>
		<tr class=TR3><td>ANATR</font></td><td>Ana Trujillo Emparedados y helados</font></td><td>Ana Trujillo</font></td><td>Owner</font></td><td>Avda. de la Constitución 2222</font></td><td>México D.F.</font></td><td>&nbsp;</font></td></tr>
		<tr class=TR1><td>ANTON</font></td><td>Antonio Moreno Taquería</font></td><td>Antonio Moreno</font></td><td>Owner</font></td><td>Mataderos  2312</font></td><td>México D.F.</font></td><td>&nbsp;</font></td></tr>
		<tr class=TR3><td>AROUT</font></td><td>Around the Horn</font></td><td>Thomas Hardy</font></td><td>Sales Representative</font></td><td>120 Hanover Sq.</font></td><td>London</font></td><td>&nbsp;</font></td></tr>
		<tr class=TR1><td>BERGS</font></td><td>Berglunds snabbköp</font></td><td>Christina Berglund</font></td><td>Order Administrator</font></td><td>Berguvsvägen  8</font></td><td>Luleå</font></td><td>&nbsp;</font></td></tr>
		<tr class=TR3><td>BLAUS</font></td><td>Blauer See Delikatessen</font></td><td>Hanna Moos</font></td><td>Sales Representative</font></td><td>Forsterstr. 57</font></td><td>Mannheim</font></td><td>&nbsp;</font></td></tr>
		<tr class=TR1><td>BLONP</font></td><td>Blondel père et fils</font></td><td>Frédérique Citeaux</font></td><td>Marketing Manager</font></td><td>24, place Kléber</font></td><td>Strasbourg</font></td><td>&nbsp;</font></td></tr>
		<tr class=TR3><td>BOLID</font></td><td>Bólido Comidas preparadas</font></td><td>Martín Sommer</font></td><td>Owner</font></td><td>C/ Araquil, 67</font></td><td>Madrid</font></td><td>&nbsp;</font></td></tr>
		<tr class=TR1><td>BONAP</font></td><td>Bon app'</font></td><td>Laurence Lebihan</font></td><td>Owner</font></td><td>12, rue des Bouchers</font></td><td>Marseille</font></td><td>&nbsp;</font></td></tr>
		</table>

		<BR>
		<INPUT Type=Button Name=B0 Class=blueButton Value="Check if the object functions properly!" OnClick="ShowAbout()">
		<INPUT Type=Button Name=B1 Class=blueButton Value="Print this document using its source code" OnClick="Print()"><BR>
		
		</Form>
			
	
	<Center><H5>Copyright 2004 - 2006 <a href="http://www.vbgold.com">VBGold Software</a> - All rights reserved.</H5></Center>

</BODY>
</HTML>
<SCRIPT LANGUAGE=VBSCRIPT>
Sub Print()
	RetVal=ASPPrinter.PrintHTMLDocFromSource(document.documentElement.outerHTML)
	MsgBox "Print Completed Successfully!",,"ASP Printer COM"
End Sub

Sub ShowAbout()
	MsgBox "This will call the About() method of the object. If the object was installed properly and IE security settings are correct, you should see the About dialog of the component immediately after this message!",vbexclamation,"ASP Printer COM"
	ASPPrinter.About()
End Sub
</SCRIPT>

