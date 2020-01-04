<!--  #INCLUDE FILE="../include/transaction.txt" -->
<html>
	<IFRAME id='oFrame' name='oFrame'  frameborder='no' style='display:none'  scrolling='no' src='blank.html'></IFRAME>
	<IFRAME id='oFrame2' name='oFrame2'  frameborder='no' style='display:none'  scrolling='no' src='blank.html'></IFRAME>

<head>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<meta name="GENERATOR" content="Microsoft FrontPage 4.0">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">

<title>File Download</title>

	<SCRIPT LANGUAGE="JavaScript">
	<!--
	
	function closeDownloading(){
		var objIFrame = document.getElementById('oFrame');
			objIFrame.src ='';
			objIFrame.style.display = "none";
	
		var objIFrame2 = document.getElementById('oFrame2');
		objIFrame2.style.position="absolute";
		objIFrame2.style.top = 0;
		objIFrame2.style.left = 0;
		objIFrame2.style.width = "400px";
		objIFrame2.style.height = "100px";
		objIFrame2.style.display = "block";
		objIFrame2.style.borderStyle = 'none' ;

	}


	var objIFrame = document.getElementById('oFrame');
	objIFrame.src ='';
	objIFrame.style.position="absolute";
	objIFrame.style.top = 0;
	objIFrame.style.left = 0;
	objIFrame.style.width = "400px";
	objIFrame.style.height = "110px";
	objIFrame.style.display = "block";
	objIFrame.style.borderStyle = 'none' ;
	
	objIFrame.src =  "processingMess.asp?sMessage=Please wait while data is being downloaded...&iMiliSecs=0";

	var objIFrame2 = document.getElementById('oFrame2');
		objIFrame2.src = "downloadOrg.asp";

	//-->
	function closeMe() 
	{
		window.self.close();
	}
	</SCRIPT>

</head>
</html>
