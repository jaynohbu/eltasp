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
</head>

<%

DIM strLocal,strNetwork,Action

	Action = Request.QueryString("Action")
	if Action ="ok" then
	
	end if	
	
	strLocal   = Request.QueryString("l")
	strNetwork = Request.QueryString("n")

	if strLocal ="" and strNetwork="" then
		response.write "<script language='javascript'>closeReturn('LPT1');</script>"
		response.end()
	end if
	
	
%>

<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" >
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0"bgcolor="#73beb6">
  <tr> 
    <td> 
     <form name=form1 method="post" action="query_print_port.asp">
       <table width="100%" border="0" cellpadding="3" cellspacing="0" bordercolor="#73beb6" class="border1px">
          <tr bgcolor="D5E8CB"> 
            <td height="8" colspan="6" align="center" valign="top" bgcolor="#ccebed" class="bodyheader">* Please select a printer port </td>
          </tr>
		            <tr align="left" valign="middle" bgcolor="#73beb6"> 
            <td colspan="2" height="1" class="bodyheader"></td>
          </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">Network Printer </td>
                      <td align="left"><input name="rb1" type="radio" id="rb2" checked="checked">
                        <strong><%=strNetwork %></strong></td>
                    </tr>
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="right" bgcolor="f3f3f3" class="bodyheader">Local Printer </td>
                      <td align="left" class="bodyheader"><input name="rb1" type="radio" id="rb1">
                        <strong><%=strLocal %></strong></td>
                    </tr>
		  <tr align="center" bgcolor="D5E8CB"> 
            <td height="20" colspan="6" valign="middle" bgcolor="#ccebed" class="bodycopy">
            <input type="button" class="bodycopy" id=Button2 style="WIDTH: 100px; BACKGROUND-COLOR: #f4f2e8" value='Ok' name="Ok" onClick="okClick();">
            <input type="button" class="bodycopy" id=Button3 style="WIDTH: 100px; BACKGROUND-COLOR: #f4f2e8" onClick="javascript:window.close();" value="Cancel" name="CloseMe"></td>
          </tr>					
        </table>
      </form></td>
  </tr>
</table>
</body>

<script language="vbscript">

sub okClick()

	if(document.form1.rb1.item(0).checked) then
		window.returnValue = "<%=strNetwork%>"
	else
		window.returnValue = "<%=strLocal%>"
	end if
		window.close()
end sub

</script>
</html>
