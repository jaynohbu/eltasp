<!--  #INCLUDE FILE="transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE FILE="connection.asp" -->
<html>
<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>	
<head>

<% 
DIM jMode
jMode = Request.QueryString("mode")

%>

    <title><%=jMode%> Client</title>
    <meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css">
    <script language='javascript'>
		window.name = 'EditCode';
    </script>
</head>
<%
Dim country
Dim PostBack	
Dim i
DIM elt_account_number,login_name,UserRight
DIM v_code,v_description

elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
login_name = Request.Cookies("CurrentUserInfo")("login_name")
UserRight = Request.Cookies("CurrentUserInfo")("user_right")	

PostBack = Request.QueryString("PostBack")
if PostBack = "" then PostBack = true

%>
<body leftmargin="0" link="336699" marginheight="0" marginwidth="0" topmargin="0"
    vlink="336699">
    <form action="all_dba_edit.asp" method="post" name="form1">
      <table align="center" border="0" bordercolor="#73beb6" cellpadding="3" cellspacing="0" class="border1px" width="100%">
        <tr bgcolor="D5E8CB">
          <td width="1%" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
          <td width="93%" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
        </tr>
        <tr bgcolor="D5E8CB">
          <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle">&nbsp;</td>
          <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle">DBA Name:</td>
        </tr>
        <tr bgcolor="D5E8CB">
          <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle">&nbsp;</td>
          <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle"><input id="txt_description" class="shorttextfield" name="txt_description" style="width: 100%;" type="text" value="<%=v_description%>"  maxlength="70"/></td>
        </tr>
        <tr bgcolor="D5E8CB" height="10px">
          <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle">&nbsp;</td>
          <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle">&nbsp;</td>
        </tr>
        <tr bgcolor="D5E8CB">
          <td align="center" bgcolor="#f3f3f3" class="bodyheader" valign="middle" colspan="2"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy" >
              <tr>
                <td><input class="bodycopy" id="bOK" style="width: 100px;height:25px " type="button" value="OK" onClick="javascript:doBtn(this);"></td>
                <td>&nbsp;</td>
                <td><input class="bodycopy" id="bCANCEL" style="width: 100px;height:25px" type="button" value="Cancel" onClick="javascript:doBtn(this);"></td>
              </tr>
          </table></td>
        </tr>
        <tr bgcolor="D5E8CB" height="10px">
          <td align="center" bgcolor="#f3f3f3" class="bodyheader" valign="middle" colspan="2">&nbsp;</td>
        </tr>
      </table>
    </form>
</body>

<script language="javascript" src="../ajaxFunctions/otherFunctions.js" type="text/javascript"></script>

<script language="javascript">

function doBtn(o) {
var oCode = document.getElementById('txt_description').value;

		switch(o.id) {
			case 'bOK' :
			window.returnValue = oCode; 
			window.close();			
				break;
			case 'bCANCEL' :
			window.returnValue = '';
			window.close();			
				break;
			default :
				break;
		}
}

</script>

</html>
