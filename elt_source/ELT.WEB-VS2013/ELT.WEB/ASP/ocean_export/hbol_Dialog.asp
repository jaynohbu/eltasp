<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>House B/L</title>
</head>
<%
rURL=Request.servervariables("QUERY_STRING")
session("HBOL_CLOSE") = ""
session("HBOL_NUM") = ""
%>

<script language="javascript">
function myLoad() {
    document.getElementById('modalFrame').src = '<%= rURL %>';
}

function myUnLoad() {
    
    var returnObj = new Object(); 
    var rVal = document.fShowModal.hReturnValue.value;
    
	if (rVal == 'cancel') {
	    returnObj.hbolNum = "";
	    returnObj.copyOption = "";
	}
	else{
	    returnObj.hbolNum = rVal;
	    returnObj.copyOption = document.fShowModal.hCopyOptionValue.value;
	    
	}
	
	if (rVal == '') {	
	    window.showModalDialog('new_edit_hbol_OK2.asp?close=yes','dialogWidth:1px; dialogHeight:1x; help:0; status:0; scroll:0;center:1;dialogHide:1');
	}
	else{	   
	    window.returnValue = returnObj;
	    self.close();
	    window.parent.ModalHandle.Modal.close();
	}
	self.close();
}

function stripeMaster(arg){
    document.fShowModal.hCopyOptionValue.value = arg;
}

</script>
<body onload="javascript:myLoad();" onunload="javascript:myUnLoad();">
<form method="post" name="fShowModal">
	<input type="hidden" name="hReturnValue">
	<input type="hidden" name="hCopyOptionValue">
</form>	
<IFRAME id="modalFrame" name="modalFrame" width="100%" frameBorder="no" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; PADDING-TOP: 0px" language="javascript" height="100%"></IFRAME>
</body>
</html>
