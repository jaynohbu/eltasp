<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Company Board</title>
    <link href="../ASPX/CSS/AppStyle.css" rel="stylesheet" type="text/css" />
</head>
<%
    string strBoardName = Request.Cookies["CurrentUserInfo"]["board_name"];
%>

<script language="javascript">
function myLoad() {
    if ('<%=strBoardName%>' == '') {
        alert('Please contact the support team to create the company board.');
    }
    else
    {
	    document.modalFrame.location = './board/list.asp?tb=' + '<%=strBoardName%>';
	}
}
</script>

<body onload="javascript:myLoad();" bottommargin="0" leftmargin="0" rightmargin="0" topmargin="0">
<form method="post" name="fShowModal" style="padding-right: 0px; padding-left: 0px; padding-bottom: 0px; margin: 0px; border-top-style: none; padding-top: 0px; border-right-style: none; border-left-style: none; border-bottom-style: none">
	<input type=hidden name="hReturnValue">
</form>	
<IFRAME id="modalFrame" name="modalFrame" width="100%" frameBorder="no" style="PADDING-RIGHT: 0px; PADDING-LEFT: 0px; PADDING-BOTTOM: 0px; MARGIN: 0px; PADDING-TOP: 0px; border-style:none" language="javascript" height="600" scrolling="yes"></IFRAME>
</body>
</html>
