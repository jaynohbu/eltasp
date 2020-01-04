<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<head>
<title>Shipping Request</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<!--  #INCLUDE FILE="../include/header.asp" -->
<!--  #include file="../include/recent_file.asp" -->
</head>

<body topmargin="0">
<table width="100%" height="12" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td align="center" valign="top"><img src="../images/spacer.gif" width="20" height="6"><img src=<% 
	
	if Not isPopWin then  
	response.write("'../images/pointer_oe.gif'") 
	end if%> width="11" height="7"><img src="../images/spacer.gif" width="360" height="6"></td>
  </tr>
</table>
<br>
<table width="95%" border="0" align="center" cellpadding="2" cellspacing="0">
  <tr> 
    <td height="32" align="left" valign="middle" class="pageheader">Shipping Request-to 
      be determined</td>
  </tr>
</table>
<table width="95%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="6D8C80" bgcolor="6D8C80" class="border1px" >
  <tr> 
    <td> <form name="form1" method="post" action="">
        <input type="hidden" name="txtCarrierDesc">
        <table width="100%" border="0" align="center" cellpadding="2" cellspacing="0" bordercolor="6D8C80">
          <tr> 
            <td height="8" align="left" valign="middle" bgcolor="BFD0C9"></td>
          </tr>
          <tr> 
            <td height="1" align="left" valign="middle" bgcolor="6D8C80"></td>
          </tr>
          <tr> 
            <td height="1" align="center" valign="middle" bgcolor="E0EDE8"><br> 
              <br></td>
          </tr>
          <tr> 
            <td height="1" align="left" valign="middle" bgcolor="#6D8C80"></td>
          </tr>
          <tr> 
            <td height="1" align="center" valign="middle" bgcolor="#BFD0C9">&nbsp;</td>
          </tr>
        </table>
      </form></td>
  </tr>
</table>
<br>
</body>
<!--  #INCLUDE FILE="../include/StatusFooter.asp" -->
</html>
