<!--  #INCLUDE FILE="../include/transaction.txt" -->
<html>
<head>
<title>Print Check</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
</head>
<%
DIM startNo,endNo,ok,nextCheckNo

startNo = Request.QueryString("startCheckNo")
endNo = Request.QueryString("endCheckNo")

ok = Request.QueryString("ok")
nextCheckNo = Request.QueryString("nextCheck")

if ok = "yes" then
		%>
			<script language="javascript">
				parent.fShowModal.hReturnValue.value = '0';
				window.top.close();
			</script>			
		<%	
end if
if ok = "no" then
		%>
			<script language="javascript">
				parent.fShowModal.hReturnValue.value = '<%=nextCheckNo%>';
				window.top.close();
			</script>			
		<%	
end if

if ok = "stop" then
		%>
			<script language="javascript">
				parent.fShowModal.hReturnValue.value = '-1';
				window.top.close();
			</script>			
		<%	
end if

%>

<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="self.focus()">
<br>
      <form method="post" name="form1">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" bgcolor="#FFFFFF" class="bodycopy">
                <tr>
                  <td class="formbody" align="right">&nbsp;</td>
                  <td class="formbody"><strong>Did your checks print OK ? </strong></td>
                </tr>
                <tr height="10px">
                  <td width="17%" class="formbody">&nbsp;</td>
                  <td width="83%" class="formbody"><div align="left"></div></td>
                </tr>
                <tr>
                  <td class="formbody"></td>
                  <td class="formbody">				  </td>
                </tr>
                <tr>
                  <td align="center">&nbsp;</td>
                  <td height="22" align="left"><input name="rb1" type="radio" id="rb1" checked="checked">
                  Yes, checks <strong><%=startNo %></strong> through <strong><%=endNo -1 %></strong> printed correctly.</td>				
                </tr>
                <tr>
                  <td align="left">&nbsp;</td>
                  <td height="22" align="left"><input name="rb1" type="radio" id="rb2" >
                  No, some checks did not print correctly. First incorrectly printed check : 
                    <select name="lstCheckNo" size="1" class="smallselect" id="lstCheckNo" style="WIDTH: 100px"  onChange="rbChange()">
						<option value="0">Select One</option>
						<% for i=startNo to endNo-1 %>
						<option value="<%= i %>"><%= i %></option>
						<% next %>
                   </select></td>				
                </tr>
                <tr>
                  <td align="left">&nbsp;</td>
                  <td height="22" align="left"><input name="rb1" type="radio" id="rb3" >
                  I didn't print any checks.</td>				
                </tr>
                
                <tr>
                  <td align="left">&nbsp;</td>
                  <td height="14" align="left">&nbsp;</td>
                </tr>
                <tr>
                  <td align="left">&nbsp;</td>
                  <td height="22" align="left"><strong>Don't forget to sign your checks! </strong></td>				
                </tr>				
        </table>
      <P align="center"><input name="OK" type="button" id="OK" value="OK" onClick="OkClick()"  style="width:70px">
      </P>
		
</form>
</body>
<script language="vbscript">
Sub rbChange
document.form1.rb1.item(1).checked  = true
End Sub

Sub OkClick

if document.form1.rb1.item(0).checked then
				document.form1.action="print_check_ok.asp?ok=yes&nextCheck="& "<%=endNo%>"
elseif document.form1.rb1.item(1).checked then
				sindex=document.form1.lstCheckNo.selectedindex
				nextCheck= document.form1.lstCheckNo.item(sindex).value
				document.form1.action="print_check_ok.asp?ok=no&nextCheck="& nextCheck
else 
				document.form1.action="print_check_ok.asp?ok=no&nextCheck=-1"
end if
				document.form1.method="POST"
				document.form1.target="_self"
				form1.submit()
End Sub

Sub CancelClick
				document.form1.action="print_check_ok.asp?ok=stop"
				document.form1.method="POST"
				document.form1.target="_self"
				form1.submit()
End Sub
</script>

</html>