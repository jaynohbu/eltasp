<html> 
<head> 
<script language="javascript"> 
<!-- 
function pageLoad() { 
var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP") 

xmlHTTP.open("get","top_check_memo.asp",false); 
xmlHTTP.send(); 
var sourceCode = xmlHTTP.responseText;
	if (sourceCode)
	{
		parent.frames['memoFrame'].document.close();
		parent.frames['memoFrame'].document.write(sourceCode);
	}
}

function intervalCall() { 
pageLoad();
setInterval("pageLoad()", 60000); 

} 

function OpenWindow(url,intWidth,intHeight) { 
      window.open(url, "msg", "width="+intWidth+",height="+intHeight+",resizable=0,scrollbars=1");
}

//-->
</Script>
</head> 
<body  bgcolor="#336699" onload="intervalCall()"> 
</html> 
