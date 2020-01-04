<html> 
<head> 
<script language="javascript"> 
<!-- 
function pageLoad() { 

	try
	{
	var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP") 

	xmlHTTP.open("get","check_memo.asp",false); 
	xmlHTTP.send(); 
	var sourceCode = xmlHTTP.responseText;
		if (sourceCode)
		{
			parent.frames['memoFrame'].document.close();
			parent.frames['memoFrame'].document.write(sourceCode);
		}
	}
	catch(e) {}

}

function intervalCall() { 
pageLoad();
setInterval("pageLoad()", 10000); 
} 

function OpenWindow(url,intWidth,intHeight) { 
      window.open(url, "msg", "width="+intWidth+",height="+intHeight+",resizable=0,scrollbars=1");
}

//-->
</Script>
</head> 
<body  bgcolor="#336699" onload="intervalCall()"> 
</html> 
