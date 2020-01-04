<html> 
<head> 

<script language="javascript"> 
<!-- 
function pageLoad(z) { 
	try
	{

var xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP") 
xmlHTTP.open("get","top_check_memo.asp",false); 

xmlHTTP.send(); 
var sourceCode = xmlHTTP.responseText;
var memoArrived;
var memoMsgDisplayedAlready;

	if (sourceCode)
	{

		if(sourceCode.indexOf("session was expired") >= 0 || sourceCode.indexOf("disconnected") >= 0)
		{
			parent.frames['memoFrame'].document.close();
			parent.frames['memoFrame'].document.write(sourceCode);
		}


		if(sourceCode.indexOf("img_memo_on") >= 0) 
		{
			memoArrived = true;
		}
		else
		{
			memoArrived = false;
		}

		var obj = parent.frames['memoFrame'].document.getElementById('img_memo_on');
		if(obj) {
			memoMsgDisplayedAlready = true;
		}
		else
		{
			memoMsgDisplayedAlready = false;
		}

		if(!z)
		{
		if(memoArrived != memoMsgDisplayedAlready) z = true;
		}
		if(z)
		{
			parent.frames['memoFrame'].document.close();
			parent.frames['memoFrame'].document.write(sourceCode);
		}

	}

	}
	catch(e) {}

}

function intervalCall() { 
pageLoad(true);
setInterval("pageLoad(false)", 50000); 
} 

function OpenWindow(url,intWidth,intHeight) { 
      window.open(url, "msg", "width="+intWidth+",height="+intHeight+",resizable=0,scrollbars=1");
}

//-->
</Script>
</head> 
<body  bgcolor="#336699" onload="intervalCall()"> 
</html> 
