<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<!--  #INCLUDE FILE="connection.asp" -->
<html>
<head>
<%  
Response.Expires = 0  
Response.AddHeader "Pragma","no-cache"  
Response.AddHeader "Cache-Control","no-cache,must-revalidate"  
%>	
<% 
DIM jMode
jMode = Request.QueryString("mode")
%>

    <title><%=jMode%> Country name</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <link href="../css/elt_css.css" rel="stylesheet" type="text/css" />
    <script type="text/jscript">
		window.name = 'EditCode';
    </script>
</head>
<%
Dim country
Dim PostBack	
Dim i
DIM code_str, code_type,elt_account_number,login_name,UserRight,code_list,default
DIM v_code,v_description

elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
login_name = Request.Cookies("CurrentUserInfo")("login_name")
UserRight = Request.Cookies("CurrentUserInfo")("user_right")	

PostBack = Request.QueryString("PostBack")
if PostBack = "" then PostBack = true

default = Request.QueryString("default")
if isnull(code_str) then
else
	default = Request.QueryString("default")
	if isnull(default) then
	else
		default = Replace(default,"'","''")
		call get_code(default)
	end if
end if
%>
<%
sub get_code( default )
		On Error Resume Next:
		DIM tmpArr
		tmpArr = Split(default,"^^")
		v_code = tmpArr(0)
		v_description =tmpArr(1)
		v_description = Replace(v_description,"""","''")
	
end sub
%>

<body leftmargin="0" link="336699" marginheight="0" marginwidth="0" topmargin="0"
    vlink="336699">
    <form action="all_code_edit.asp" method="post" name="form1">
      <table align="center" border="0" bordercolor="#73beb6" cellpadding="3" cellspacing="0" class="border1px" width="100%">
        <tr bgcolor="D5E8CB">
          <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
          <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
          <td width="1%" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
          <td width="93%" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
        </tr>
        <tr bgcolor="D5E8CB">
          <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
          <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">Country Code :</td>
          <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle">&nbsp;</td>
          <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle">Country Name :</td>
        </tr>
        <tr bgcolor="D5E8CB">
          <td width="6%" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
          <td width="6%" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader"><input id="txt_code" name="txt_code" style="width:100px;" type="text" value="<%= v_code%>"  maxlength="2" <% if jMode="Modify" then 
									response.write "readonly='true'" 
									response.write " class='d_shorttextfield'" 
								else
									response.write " class='shorttextfield'" 								
								end if
								%> /></td>
          <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle">&nbsp;</td>
          <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle"><input id="txt_description" class="shorttextfield" name="txt_description" style="width: 100%;" type="text" value="<%=v_description%>"  maxlength="70"/></td>
        </tr>
        <tr bgcolor="D5E8CB" height="10px">
          <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
          <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
          <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle">&nbsp;</td>
          <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle">&nbsp;</td>
        </tr>
        <tr bgcolor="D5E8CB">
          <td align="center" bgcolor="#f3f3f3" class="bodyheader" valign="middle" colspan="4"><table border="0" cellpadding="0" cellspacing="0" class="bodycopy" >
              <tr>
                <td><input class="bodycopy" id="bOK" style="width: 100px;height:25px " type="button" value="OK" onClick="javascript:doBtn(this);"></td>
                <td>&nbsp;</td>
                <td><input class="bodycopy" id="bCANCEL" style="width: 100px;height:25px" type="button" value="Cancel" onClick="javascript:doBtn(this);"></td>
              </tr>
          </table></td>
        </tr>
        <tr bgcolor="D5E8CB" height="10px">
          <td align="center" bgcolor="#f3f3f3" class="bodyheader" valign="middle" colspan="4">&nbsp;</td>
        </tr>
      </table>
    </form>
</body>

<script language="javascript" src="../ajaxFunctions/otherFunctions.js" type="text/javascript"></script>
<script language="javascript">
function doBtn(o) {
var oCode = document.getElementById('txt_code').value;
var oDesc = document.getElementById('txt_description').value;
			s = oCode + "^^^" + oDesc;
		switch(o.id) {
			case 'bOK' :
			window.returnValue = s; 
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
document.getElementById('txt_description').focus();
</script>

</html>
