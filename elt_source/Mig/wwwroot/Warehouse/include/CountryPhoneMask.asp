<!--  #INCLUDE FILE="transaction.txt" -->
<% Option Explicit %>
<!--  #INCLUDE FILE="connection.asp" -->
<html>
<head>
<title>Phone Format</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<script language='javascript'>
window.name = 'PhoneFormat';
</script>
<style type="text/css">
<!--
body {
	background-color: #f3f3f3;
}
.style2 {font-size: 10}
-->
</style></head>
<%
Dim country
Dim PostBack	
Dim i
DIM code_type,elt_account_number,login_name,UserRight
DIM	country_list
DIM v_country_code,v_phone_prefix,v_phone_mask,v_free_form,v_original_phone_prefix
elt_account_number = Request.Cookies("CurrentUserInfo")("elt_account_number")
login_name = Request.Cookies("CurrentUserInfo")("login_name")
UserRight = Request.Cookies("CurrentUserInfo")("user_right")	

		PostBack = Request.QueryString("PostBack")
        if PostBack = "" then PostBack = true
		
		country = Request.QueryString("country")
		call set_default_country		
	    call get_country
%>

<%
sub set_default_country
		if isnull(country) then
			country = "US"
		end if
		
		if TRIM(country) = "" then
			country = "US"
		end if 
end sub
%>

<%
sub get_country
DIM rs,SQL
DIM tmpTable

	set country_list = Server.CreateObject("System.Collections.ArrayList")
	
'	SQL = "select country_code, substring(country_name,0,40) as country_name, isnull(phone_prefix,'') as phone_prefix, isnull(phone_mask,'') as phone_mask, isnull(free_form,'') as free_form from all_country_code order by country_name" 
	SQL = "select a.country_code, substring(a.country_name,0,40) as country_name, isnull(a.phone_prefix,'') as phone_prefix, isnull(a.phone_mask,'') as phone_mask, isnull(a.free_form,'') as free_form from all_country_code a inner join country_code b on a.country_code = b.country_code where b.elt_account_number =" & elt_account_number & " order by a.country_name"	
	Set rs = eltConn.Execute(SQL)

	Do While Not rs.EOF
		Set tmpTable = Server.CreateObject("System.Collections.HashTable")
		tmpTable.Add "country_code",rs("country_code").value
		tmpTable.Add "country_name",rs("country_name").value  & fill_space ( rs("country_name").value,40 ) 
		tmpTable.Add "phone_prefix",rs("phone_prefix").value
		tmpTable.Add "phone_mask",rs("phone_mask").value
		tmpTable.Add "free_form",rs("free_form").value
		country_list.Add tmpTable	
		rs.MoveNext
	Loop
	rs.Close
end sub
%>
<% 
function fill_space( s, spaceLen )
DIM i,tL,tmpS
tL = spaceLen - LEN(s)
tmpS = ""

if tL <= 0 then
	fill_space = ""
	exit function
end if

For i = 0  to tL
	tmpS = tmpS & "&nbsp;"
Next

fill_space = tmpS
end function
%>

<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
     <form name=form1 method="post" action="AddClient.asp">
       <table width="90%" border="0" align="center" cellpadding="0" cellspacing="0" bordercolor="#73beb6" bgcolor="#FFFFFF" class="maskwindow">
          <tr bgcolor="D5E8CB"> 
              <td height="8" colspan="3" align="center" valign="top" bgcolor="#ccebed" class="bodyheader"></td>
          </tr>
		            <tr align="left" valign="middle" bgcolor="#73beb6">       
            			<td colspan="3" height="1" class="bodyheader"></td>
		   			</tr>
                    
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
					<td height="22" bgcolor="#f3f3f3"></td>
                      <td height="22" colspan="2" align="left" bgcolor="#f3f3f3"><span class="bodyheader">Country</span></td>
			        </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                        <td height="8" colspan="3" bgcolor="#FFFFFF"></td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
					<td bgcolor="#FFFFFF"></td>
                      <td colspan="2" align="left" bgcolor="#FFFFFF"><select name="lstCountry" size="4"  class="smallselect" style="height:200px;WIDTH: 350px;font-size: 11px; font-family:'Courier New', Courier, monospace;" onChange="javascript:lstCountry_on_change(this);">
                        <% if Not IsNull(country_list) And Not isEmpty(country_list) Then %>
                        <% for i=0 To country_list.count-1 %>
                        <option value='<%=country_list(i)("country_code")&"^"&country_list(i)("phone_prefix")& "^" & country_list(i)("phone_mask")%>' <% 
						if country_list(i)("country_code") = country then 
								response.write "selected" 
								v_phone_mask = 	country_list(i)("phone_mask")
								v_original_phone_prefix = country_list(i)("phone_prefix")
						end if				
						%>><%= country_list(i)("country_name") %><%= country_list(i)("phone_prefix") %></option>
                        <% next %>
                        <% end if %>
                      </select>
</td>
			        </tr>
                    <tr align="left" valign="middle" bgcolor="#73beb6">       
            			<td colspan="3" height="1" class="bodyheader"></td>
		   			</tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td align="left" bgcolor="#F3f3f3">&nbsp;</td>
                      <td height="22" colspan="2" align="left" bgcolor="#F3f3f3"><span class="bodyheader"> Phone Number Format</span></td>
                    </tr>
                    
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td align="center" bgcolor="#FFFFFF">&nbsp;</td>
                      <td width="4%" align="left" bgcolor="#FFFFFF" class="bodycopy"><input id="radiobutton0" type="checkbox" name="radiobutton" value="radiobutton" onClick="javascript:rClick(this);"/>                                </td>
                      <td width="93%" align="left" bgcolor="#FFFFFF"><span class="style2">
                          <label for="radiobutton0">Free form</label>
                      </span></td>
                    </tr>
                    
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td align="center" bgcolor="#FFFFFF">&nbsp;</td>
                      <td align="left" bgcolor="#FFFFFF" class="bodycopy"><input id="radiobutton1" type="checkbox" name="radiobutton" value="radiobutton" onClick="javascript:rClick(this);"/>                               </td>
                      <td align="left" bgcolor="#FFFFFF">
                          <label for="radiobutton0">Free form with international phone number</label></td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td align="center" bgcolor="#FFFFFF">&nbsp;</td>
                      <td align="left" bgcolor="#FFFFFF" class="bodycopy"><input id="radiobutton2" type="checkbox" name="radiobutton" value="radiobutton" onClick="javascript:rClick(this);"  checked="checked"/>                                </td>
                      <td align="left" bgcolor="#FFFFFF">
                          <label for="radiobutton2">Apply  format without Country Code</label></td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td align="center" bgcolor="#FFFFFF">&nbsp;</td>
                      <td align="left" bgcolor="#FFFFFF" class="bodycopy"><input id="radiobutton3" type="checkbox" name="radiobutton" value="radiobutton" onClick="javascript:rClick(this);"/>                                </td>
                      <td align="left" bgcolor="#FFFFFF"><label for="radiobutton2">Apply  format with Country Code</label></td>
                    </tr>
          <tr align="left" valign="middle" bgcolor="f3f3f3">
            <td width="3%" align="left" bgcolor="#FFFFFF">&nbsp;</td> 
            <td height="30" colspan="2" align="left" bgcolor="#FFFFFF" class="bodycopy"><span class="bodyheader">
                <input id="txt_phone_mask" class="bodycopy" name="txt_phone_mask" style="width: 160px" value="<%=v_phone_mask%>">
            </span></td>
           </tr>
		   <tr align="left" valign="middle" bgcolor="#73beb6">
            <td height="1" colspan="3" class="bodyheader"></td>
           </tr>
		  <tr align="center" bgcolor="D5E8CB"> 
            <td height="20" colspan="3" valign="middle" bgcolor="#ccebed" class="bodycopy">
<input type="button" class="bodycopy" id=Button2 style="WIDTH: 100px; BACKGROUND-COLOR: #f4f2e8" value='OK' name="AddTo" onClick="javascript:ApplyMask();">
<input type="button" class="bodycopy" id=Button3 style="WIDTH: 100px; BACKGROUND-COLOR: #f4f2e8" onClick="javascript:window.close();" value="Close" name="CloseMe"></td>
          </tr>
       </table>
</form>
</body>
<script language="javascript" type="text/javascript" src="../ajaxFunctions/otherFunctions.js"></script>
<script language="javascript">
function rClick(o) {
}
function ApplyMask() {
var oSelect = document.getElementById('lstCountry');
var	s = oSelect.options[ oSelect.options.selectedIndex ].value;

	if (document.getElementById('radiobutton3').checked) {
		window.returnValue = s + '^' + '<%=v_original_phone_prefix%>';
	}
	else if (document.getElementById('radiobutton2').checked) {
		p0 = s.indexOf('^')+1;
		p1 = s.lastIndexOf('^')+1;
		s = s.substring(0,p0) + '^' + s.substring(p1);
		window.returnValue = s + '^' + '<%=v_original_phone_prefix%>';	
	} 
	else if (document.getElementById('radiobutton1').checked) {
		s = s.substring(0,s.lastIndexOf('^')+1);
		window.returnValue = s + '^' + '<%=v_original_phone_prefix%>';	
	} 
	else {
		s = s.substring(0,s.indexOf('^')+1);
		window.returnValue = s + '^^'+ '<%=v_original_phone_prefix%>';
	}
	window.close();
}

function lstCountry_on_change(o) {
var oTextBox = document.getElementById('txt_phone_mask');
	oTextBox.value = o.value.substring(o.value.lastIndexOf('^')+1);
}

</script>
</html>
