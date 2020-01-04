<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Public Board</title>
</head>

<script language="javascript">
function myLoad() {
	document.modalFrame.location = './board/list.asp?tb=inno_1';
}
</script>

<body onload="javascript:myLoad();" bottommargin="0" leftmargin="0" rightmargin="0" topmargin="0">
<form method="post" name="fShowModal">
	<input type=hidden name="hReturnValue">
<IFRAME id="modalFrame" name="modalFrame" width="100%" frameBorder="no" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; PADDING-TOP: 0px" language="javascript" height="600" scrolling="auto"></IFRAME>
</form>	
</body>
</html>
