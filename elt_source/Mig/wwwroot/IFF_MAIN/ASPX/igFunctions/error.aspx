<%@ Page language="c#" Inherits="igFunctions.Error" validateRequest="false" CodeFile="Error.aspx.cs" %>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<HTML>
  <HEAD>
		<title>Error</title>
		<LINK href="/Css/Board.css" type="text/css" rel="stylesheet"><LINK 
href="../CSS/AppStyle.css" type=text/css 
rel=stylesheet >
  <!--  #INCLUDE FILE="../include/common.htm" -->
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1"><style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style1 {color: #1b4d89}
-->
</style></HEAD>
	<body>
		<form method="post" runat="server">
			<table width="500" height="500" border="0" align="center" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF">
				<tr height="30%">
					<td>&nbsp;</td>
				</tr>
				<tr>
				  <td height="40%"><table width="400" border="0" align="center" cellpadding="0" cellspacing="0" class="bodycopy">
                    <tr>
                      <td width="79" align="center" valign="middle" class="bodycopy"><img src="/iff_main/Images/error.gif" width="50" height="50"></td>
                      <td width="1" bgcolor="b5d0f1"></td>
                      <td width="20"></td>
                      <td width="300" class="bodycopy"><strong>System Error</strong><br>
                        <br>
                        If this problem persists, please contact support center or <br>
                        e-mail to <a href="mailto:support@e-logitech.net">support@e-logitech.net</a>.</td>
                    </tr>
                  </table></td>
			  </tr>
				<tr>
					<td height="30%"><asp:Label CssClass="bodycopy" ID="lblError" runat="server"></asp:Label></td>
				</tr>
		  </table>
		</form>
	</body>
</HTML>
