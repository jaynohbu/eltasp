<!--  #INCLUDE FILE="transaction.txt" -->
<% Option Explicit %>
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

    <title><%=jMode%> Code</title>
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
DIM code_str, code_type,elt_account_number,login_name,UserRight,code_list,default
DIM v_code,v_description,code_desc

elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
login_name = Request.Cookies("CurrentUserInfo")("login_name")
UserRight = Request.Cookies("CurrentUserInfo")("user_right")	

PostBack = Request.QueryString("PostBack")
if PostBack = "" then PostBack = true

code_str = Request.QueryString("type")
code_desc = Request.QueryString("desc")
default = Request.QueryString("default")
if isnull(code_desc) then
	code_desc = ""
else
	if isnull(default) then
	else
		default = Replace(default,"'","''")
		default = Replace(default,"^^^",",")
		call get_code(code_str, default)
	end if
end if
%>
<%
sub get_code( code_type, default )
DIM rs,SQL

	set code_list = Server.CreateObject("System.Collections.ArrayList")
	SQL = "select code, isnull(description,'') as description from all_code where elt_account_number=" & elt_account_number & " and type=" & code_type & " and code='"&default&"'"

	Set rs = eltConn.Execute(SQL)
	if Not rs.EOF then
		v_code = rs("code")
		v_description = rs("description")
		v_description = Replace(v_description,"""","''")
	end if
	rs.Close
	
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
          <td align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader"><%=code_desc%>:</td>
          <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle">&nbsp;</td>
          <td align="left" bgcolor="#f3f3f3" class="bodyheader" valign="middle">Description:</td>
        </tr>
        <tr bgcolor="D5E8CB">
          <td width="6%" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader">&nbsp;</td>
          <td width="6%" align="left" valign="middle" bgcolor="#f3f3f3" class="bodyheader"><input id="txt_code" name="txt_code" style="width: 150px;" type="text" value="<%= v_code%>"  maxlength="20" <% if jMode="Modify" then 
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

</script>

</html>
