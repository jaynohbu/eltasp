<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Print Check</title>
</head>
<%
rURL=Request.servervariables("QUERY_STRING")
%>

<script language="javascript">
function myLoad() {
	document.modalFrame.location = '<%= rURL %>';
}


function myUnLoad() {
window.returnValue = document.fShowModal.hReturnValue.value;
}

function resize_iframe()
{
    var x,y;
    if (self.innerHeight) // all except Explorer
    {
	    x = self.innerWidth;
	    y = self.innerHeight;
    }
    else if (document.documentElement && document.documentElement.clientHeight)
	    // Explorer 6 Strict Mode
    {
	    x = document.documentElement.clientWidth;
	    y = document.documentElement.clientHeight;
    }
    else if (document.body) // other Explorers
    {
	    x = document.body.clientWidth;
	    y = document.body.clientHeight;
    }

	document.getElementById("modalFrame").style.height=x;
}

window.onresize=resize_iframe; 

</script>
<body onload="javascript:myLoad();resize_iframe();" onunload="javascript:myUnLoad();">
<form method="post" name="fShowModal">
	<input type=hidden name="hReturnValue">
</form>	
<IFRAME id="modalFrame" name="modalFrame" width="100%" frameBorder="no" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; PADDING-TOP: 0px" language="javascript" height="100%"></IFRAME>
</body>
</html>
