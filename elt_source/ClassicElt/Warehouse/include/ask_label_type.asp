<!--  #INCLUDE FILE="transaction.txt" -->
<% Option Explicit %>
<html>
<head>
<title>Select a Print Port</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
<script language='javascript'>
window.name = 'query_print_port';
function closeReturn(s) 
{
	window.returnValue = s;
	window.close();
}
</script>
<!--  #INCLUDE FILE="connection.asp" -->
<!--  #INCLUDE FILE="header.asp" -->
</head>

<%

DIM strLocal,strNetwork,Action,vAdd_Info,vLabelType

	Action = Request.QueryString("Action")
	if Action ="ok" then
	
	end if	
	
	strLocal   = Request.QueryString("l")
	strNetwork = Request.QueryString("n")

	if strLocal ="" and strNetwork="" then
		response.write "<script language='javascript'>closeReturn('LPT1');</script>"
		response.end()
	end if
	
	DIM rs,SQL
	SQL = "select * from users where elt_account_number = " & elt_account_number & " and userid=" & user_id
	Set rs = eltConn.execute (SQL)
	if Not rs.EOF then
		vLabelType=rs("label_type")
		if isnull(vLabelType) then
			 vLabelType =1
		end if 
		vAdd_Info=rs("add_to_label")	
	end if	
	rs.Close	 
set rs = nothing

%>

<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0"bgcolor="#E5D4E3">
  <tr> 
    <td> 
     <form name=form1 method="post" action="query_print_port.asp">
       <table width="100%" border="0" cellpadding="3" cellspacing="0" bordercolor="#E5D4E3" class="border1px">
          <tr bgcolor="E5D4E3"> 
            <td height="8" colspan="6" align="center" valign="top" bgcolor="#f0e7ef" class="bodyheader">* Please select a printer port</td>
          </tr>
		            <tr align="left" valign="middle" bgcolor="#E5D4E3"> 
            <td colspan="2" height="1" class="bodyheader"></td>
          </tr>
                    
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">Network Printer </td>
                      <td align="left"><input name="rb1" type="radio" id="rb2" <% if strNetwork <> "" then response.write "checked='checked'" %><% if strNetwork = "" then response.write " disabled='disabled'" end if%>>
                        <strong><% if strNetwork = "" then response.write "N/A" else response.write(strNetwork) end if %></strong></td>
                    </tr>                    
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td width="29%" height="22" align="right" bgcolor="f3f3f3" class="bodyheader">Local Printer </td>
                      <td width="71%" align="left" class="bodyheader"><input name="rb1" type="radio" id="rb1" <% if strNetwork = "" and strLocal <> "" then response.write "checked='checked'" %><% if strLocal = "" then response.write " disabled='disabled'" end if%>>
                      <strong>
					  <% if strLocal = "" then 
						  response.write "N/A" 
					  else 						  
					  	response.write(strLocal) 
					  end if %></strong></td>
                    </tr>
                    
          <tr bgcolor="E5D4E3"> 
            <td height="8" colspan="6" align="center" valign="top" bgcolor="#f0e7ef" class="bodyheader">* Addtional option </td>
          </tr>
		  <!--
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">Label type</td>
                      <td align="left" class="bodyheader"><select class="smallselect" name="lst_label_type"
                                                            size="1" style="width: 214px">
                                                            <option value="1" select>Default Type</option>
                                                        </select></td>
                    </tr> -->
                    
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">&nbsp;</td>
                      <td align="left" class="bodyheader"><input id="chk_iata" name="chk_iata" onClick="javascript:cClick(this);" type="checkbox" style="cursor:hand" checked='checked' value='Y'/>
                        <label for="chk_iata">Print  IATA label</label></td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">&nbsp;</td>
                      <td align="left" class="bodyheader"><input id="chk_address" name="chk_address" onClick="javascript:cClick(this);" type="checkbox" style="cursor:hand" <% if vAdd_Info="Y" then response.write(" checked='checked' ") %> <% if vAdd_Info="Y" then response.write("value='Y'") %> />
                        <label for="chk_address_only">Print  address label</label></td>
                    </tr>
                    
		  <tr align="center" bgcolor="D5E8CB"> 
            <td height="20" colspan="2" valign="middle" bgcolor="#E5D4E3" class="bodycopy">
            <input type="button" class="bodycopy" id=Button2 style="WIDTH: 100px; BACKGROUND-COLOR: #f4f2e8" value='Ok' name="Ok" onClick="okClick();">
            <input type="button" class="bodycopy" id=Button3 style="WIDTH: 100px; BACKGROUND-COLOR: #f4f2e8" onClick="javascript:window.close();" value="Cancel" name="CloseMe"></td>
          </tr>					
        </table>
      </form></td>
  </tr>
</table>
</body>

<script language="vbscript">
sub cClick(o)

if(o.checked) then
	o.value = "Y"
else
	o.value = ""
end if
	
end sub

sub okClick()
DIM add_option,label_type,vPort
	
	add_option = ""		
	
	if document.getElementById("chk_iata").checked then
		add_option = "I"
	end if

	if document.getElementById("chk_address").checked then
		add_option = "A"
	end if

	if document.getElementById("chk_iata").checked and document.getElementById("chk_address").checked then
		add_option = "X"
	end if	
	
//	label_type = document.getElementById("lst_label_type").options( document.getElementById("lst_label_type").options.selectedIndex ).value
	label_type = 1
	if(document.form1.rb1.item(0).checked) then
		vPort = "<%=strNetwork%>" 
	else
		vPort = "<%=strLocal%>"  
	end if
	if add_option = "" then
		window.returnValue = ""
	else	
		window.returnValue = vPort & "^^^" & add_option & "^^^" & label_type
	end if	
	window.close()
		
end sub

</script>
</html>
