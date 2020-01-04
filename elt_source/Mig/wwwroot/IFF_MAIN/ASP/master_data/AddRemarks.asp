<%@  transaction="supported" language="vbscript" codepage="65001" %>
<% 
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>

<link href="../css/elt_css.css" rel="stylesheet" type="text/css" />

<title>Remarks</title>
</head>
<%
vOrgNum = Request.QueryString("Num")
vOrgName = Request.QueryString("Name")
%>

<script type="text/jscript" >
function myLoad() {
	var loc = "/IFF_MAIN/Board/board/listRemarks.asp?tb=Remarks&Start=yes&oNum=" + '<%= vOrgNum %>' + '&oName=' + encodeURIComponent("<%= vOrgName %>") ;
	document.modalFrame.location = loc;
}


function myUnLoad() {
var rVal = document.fShowModal.hReturnValue.value;

	if (rVal == 'cancel') 
	{
	window.returnValue = '';
	}
	else
	{
	window.returnValue = document.fShowModal.hReturnValue.value;
	}
	
}

function resize_obj(arg)
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
        if(document.getElementById(arg)!=null){
            //alert (y);
	        document.getElementById(arg).style.height=parseInt(y-
	        document.getElementById(arg).offsetTop)+"px";
	    }	    
    }

window.onresize=resize_obj("modalFrame");

</script>
<body onload="javascript:myLoad(); resize_obj('modalFrame');" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
<form method="post" name="fShowModal">
	<input type=hidden name="hReturnValue">
   	<input type=hidden name="hOrgNum" Value="<%= vOrgNum %>">	
</form>	
<IFRAME id="modalFrame" name="modalFrame" width="100%" height="100%" frameBorder="no" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; PADDING-TOP: 0px" language="javascript" scrolling="yes"></IFRAME>
</body>
</html>
