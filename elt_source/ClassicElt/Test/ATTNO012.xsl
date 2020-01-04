<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
<html>
<head>
<script language="JavaScript" src="menu.js"></script>
<script language="JavaScript" src="print.js"></script>
<title>이력서</title>
<style type="text/css">
	td, Select {font-family:굴림체,Arial; font-size:11pt;}
	td.value {font-family:굴림체,Arial; font-weight:lighter; font-size:11pt;}
	.value {font-family:굴림체,Arial; font-weight:lighter; font-size:11pt;}
</style>
</head>
<body>
<!-- Document Start -->                                                                                       
<table border="1" align="center" width="1000px" height="700" cellspacing="0" cellpadding="0" style="border-collapse:collapse;border:none;">    
	<tr>                                                                                                          
		<td valign="top">
			<p style="margin-top:40;font-size:20px;font-weight:bold;" align="center">                         
				이&#160;&#160;&#160;&#160;&#160;&#160;력&#160;&#160;&#160;&#160;&#160;&#160;서
			</p>                                                                                                  
			<p style="margin-left:10px;margin-top:40px;margin-bottom:0px;">                                     
				성&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;명&#160;:
				<xsl:value-of select="이력서/성명"/>
			</p>                                                                                                  
				<p style="margin-left:10px;margin-top:10px;margin-bottom:0px;">                                     
				직&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;위&#160;:                          
				<xsl:value-of select="이력서/직위"/>
			</p>                                                                                                  
			<p style="margin-left:10px;margin-top:10px;margin-bottom:0px;">                                     
				주&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;소&#160;:                          
			<xsl:value-of select="이력서/주소"/>
			</p>                                                                                                  
			<p style="margin-left:10px;margin-top:10px;margin-bottom:0px;">                                     
				주민&#160;등록&#160;번호&#160;:                                                                  
				<xsl:value-of select="이력서/주민번호"/>                   
			</p>                                                                                                  
			<p style="margin-left:10px;margin-top:10px;margin-bottom:40px;">                                    
				자&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;격&#160;:                          
			<xsl:value-of select="이력서/자격"/>
			</p>                                                                                                  
			<p style="margin-top:30;margin-bottom:10px;font-size:14pt;font-weight:bold;" align="center">      
				학력&#160;및&#160;경력                                                   
			</p>
			<p style="margin-top:30;margin-bottom:10px;font-size:14pt;font-weight:bold;" align="center">
				<blockquote>
					<xsl:copy-of select="이력서/학력및경력/*"/>
				</blockquote>
			</p>
		</td>
	</tr>
</table>
<OBJECT ID="IEPrint" WIDTH="1" HEIGHT="1" CLASSID="CLSID:F290B058-CB26-460E-B3D4-8F36AEEDBE44" codebase="/util/IEPrint/IEPrint.cab#version=1,0,1,1">
	<PARAM NAME="LPKPath" VALUE="/util/IEPrint/Teos.lpk"></PARAM>
</OBJECT><script language="JavaScript" >
function fprint()
{
	/*
	print(leftmargin, rightmargin, topmargin, bottommargin, headertitle, footertitle, printbg, landscape, printType)
	leftmargin		: 왼쪽 여백(단위:mm)
	rightmargin		: 오른쪽 여백(단위:mm)
	topmargin			: 윗쪽여백
	bottommargin	: 아래쪽 여백
	headertitle		: 머리말
	footertitle		: 꼬리말
	printbg				: true 를 넣으면 배경색, 배경이미지가 출력
	landscape			: true : 가로, false : 세로
	printType			: 'prev'는 미리보기 화면으로 나머지는 바로 인쇄
	*/
	print(10, 10, 10, 10, '', '', true, true, 'print');	
}
function fprevview()
{
	/*
	print(leftmargin, rightmargin, topmargin, bottommargin, headertitle, footertitle, printbg, landscape, printType)
	leftmargin		: 왼쪽 여백(단위:mm)
	rightmargin		: 오른쪽 여백(단위:mm)
	topmargin			: 윗쪽여백
	bottommargin	: 아래쪽 여백
	headertitle		: 머리말
	footertitle		: 꼬리말
	printbg				: true 를 넣으면 배경색, 배경이미지가 출력
	landscape			: true : 가로, false : 세로
	printType			: 'prev'는 미리보기 화면으로 나머지는 바로 인쇄
	*/
	print(10, 10, 10, 10, '', '', true, true, 'prev');	
}
</script>
</body>
</html>
</xsl:template>
</xsl:stylesheet>