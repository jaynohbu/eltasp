<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <title>HAWB Number</title>
</head>
<%
rURL=Request.servervariables("QUERY_STRING")
session("HAWB_CLOSE") = ""
session("HAWB_NUM") = ""
%>

<script language="javascript">
function myLoad(){
	document.modalFrame.location = '<%= rURL %>';
}

function myUnLoad(){
    var returnObj = new Object(); 
    var rVal = document.fShowModal.hReturnValue.value;
	
	if (rVal == 'cancel') {
	    returnObj.hawbNum = "";
	    returnObj.copyOption = "";
	}
	else{
	    returnObj.hawbNum = rVal;
	    returnObj.copyOption = document.fShowModal.hCopyOptionValue.value;
	}
	
	if (rVal == '') {	
	    window.showModalDialog('new_edit_hawb_OK2.asp?close=yes','dialogWidth:1px; dialogHeight:1x; help:0; status:0; scroll:0;center:1;dialogHide:1');
	}
	else{
	    window.returnValue = returnObj;
	}
}

function stripeMaster(arg){
    document.fShowModal.hCopyOptionValue.value = arg;
}

</script>

<body onload="javascript:myLoad();" onunload="javascript:myUnLoad();">
    <form method="post" name="fShowModal">
        <input type="hidden" name="hReturnValue" id="hReturnValue">
        <input type="hidden" name="hCopyOptionValue" id="hCopyOptionValue">
    </form>
    <IFRAME id="modalFrame" name="modalFrame" width="100%" frameBorder="no" style="padding-right: 0px;
        padding-left: 0px; padding-bottom: 0px; margin: 0px; padding-top: 0px" language="javascript"
        height="100%"></IFRAME>
</body>
</html>