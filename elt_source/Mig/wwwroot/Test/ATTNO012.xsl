<?xml version="1.0" encoding="euc-kr"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

<xsl:template match="/">
<html>
<head>
<script language="JavaScript" src="menu.js"></script>
<script language="JavaScript" src="print.js"></script>
<title>�̷¼�</title>
<style type="text/css">
	td, Select {font-family:����ü,Arial; font-size:11pt;}
	td.value {font-family:����ü,Arial; font-weight:lighter; font-size:11pt;}
	.value {font-family:����ü,Arial; font-weight:lighter; font-size:11pt;}
</style>
</head>
<body>
<!-- Document Start -->                                                                                       
<table border="1" align="center" width="1000px" height="700" cellspacing="0" cellpadding="0" style="border-collapse:collapse;border:none;">    
	<tr>                                                                                                          
		<td valign="top">
			<p style="margin-top:40;font-size:20px;font-weight:bold;" align="center">                         
				��&#160;&#160;&#160;&#160;&#160;&#160;��&#160;&#160;&#160;&#160;&#160;&#160;��
			</p>                                                                                                  
			<p style="margin-left:10px;margin-top:40px;margin-bottom:0px;">                                     
				��&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;��&#160;:
				<xsl:value-of select="�̷¼�/����"/>
			</p>                                                                                                  
				<p style="margin-left:10px;margin-top:10px;margin-bottom:0px;">                                     
				��&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;��&#160;:                          
				<xsl:value-of select="�̷¼�/����"/>
			</p>                                                                                                  
			<p style="margin-left:10px;margin-top:10px;margin-bottom:0px;">                                     
				��&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;��&#160;:                          
			<xsl:value-of select="�̷¼�/�ּ�"/>
			</p>                                                                                                  
			<p style="margin-left:10px;margin-top:10px;margin-bottom:0px;">                                     
				�ֹ�&#160;���&#160;��ȣ&#160;:                                                                  
				<xsl:value-of select="�̷¼�/�ֹι�ȣ"/>                   
			</p>                                                                                                  
			<p style="margin-left:10px;margin-top:10px;margin-bottom:40px;">                                    
				��&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;&#160;��&#160;:                          
			<xsl:value-of select="�̷¼�/�ڰ�"/>
			</p>                                                                                                  
			<p style="margin-top:30;margin-bottom:10px;font-size:14pt;font-weight:bold;" align="center">      
				�з�&#160;��&#160;���                                                   
			</p>
			<p style="margin-top:30;margin-bottom:10px;font-size:14pt;font-weight:bold;" align="center">
				<blockquote>
					<xsl:copy-of select="�̷¼�/�з¹װ��/*"/>
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
	leftmargin		: ���� ����(����:mm)
	rightmargin		: ������ ����(����:mm)
	topmargin			: ���ʿ���
	bottommargin	: �Ʒ��� ����
	headertitle		: �Ӹ���
	footertitle		: ������
	printbg				: true �� ������ ����, ����̹����� ���
	landscape			: true : ����, false : ����
	printType			: 'prev'�� �̸����� ȭ������ �������� �ٷ� �μ�
	*/
	print(10, 10, 10, 10, '', '', true, true, 'print');	
}
function fprevview()
{
	/*
	print(leftmargin, rightmargin, topmargin, bottommargin, headertitle, footertitle, printbg, landscape, printType)
	leftmargin		: ���� ����(����:mm)
	rightmargin		: ������ ����(����:mm)
	topmargin			: ���ʿ���
	bottommargin	: �Ʒ��� ����
	headertitle		: �Ӹ���
	footertitle		: ������
	printbg				: true �� ������ ����, ����̹����� ���
	landscape			: true : ����, false : ����
	printType			: 'prev'�� �̸����� ȭ������ �������� �ٷ� �μ�
	*/
	print(10, 10, 10, 10, '', '', true, true, 'prev');	
}
</script>
</body>
</html>
</xsl:template>
</xsl:stylesheet>