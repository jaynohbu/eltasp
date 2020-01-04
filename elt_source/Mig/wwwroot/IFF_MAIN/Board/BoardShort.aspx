<%@ Page Language="C#" AutoEventWireup="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Board Preview</title>
<link href="../ASP/css/elt_css.css" rel="stylesheet" type="text/css">

</head>
<body>
    <form id="form1" runat="server">
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" >
        <tr>
    <td>
	</td>
    <td>
	<% if ( Request.Cookies["CurrentUserInfo"]["elt_account_number"] == "80002000" && Request.Cookies["CurrentUserInfo"]["login_name"] == "admin" ){ %>
	<iframe src="/IFF_MAIN/BOARD/main_list_1.asp" FRAMEBORDER="no" MARGINWIDTH="0" MARGINHEIGHT="0" SCROLLING="no" width="700px"></iframe>
	<% } %>
	</td>
    <td>&nbsp;</td>
  </tr>
        <tr>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
    <td>&nbsp;</td>
  </tr>
        <tr>
    <td>&nbsp;</td>
    <td>
	<% if ( Request.Cookies["CurrentUserInfo"]["elt_account_number"] == "80002000" && Request.Cookies["CurrentUserInfo"]["login_name"] == "admin" ){ %>
	<iframe src="/IFF_MAIN/BOARD/main_list_2.asp" frameborder="no" marginwidth="0" marginheight="0" scrolling="No" width="700px"></iframe>
	<% } %>
	</td>
    <td>&nbsp;</td>
  </tr>
</table>

    </form>
</body>
</html>
