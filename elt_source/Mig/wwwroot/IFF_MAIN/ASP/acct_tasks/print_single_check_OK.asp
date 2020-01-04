<!--  #INCLUDE FILE="../include/transaction.txt" -->
<html>
<head>
<title>Print Check</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
</head>
<%
DIM startNo,ok,nextCheckNo

startNo = Request.QueryString("CheckNo")

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
                  <td width="24%" class="formbody">&nbsp;</td>
                  <td width="76%" class="formbody"><div align="left"></div></td>
                </tr>
                <tr>
                  <td class="formbody"></td>
                  <td class="formbody">				  </td>
                </tr>
                <tr>
                  <td align="center">&nbsp;</td>
                  <td height="22" align="left"><input name="rb1" type="radio" id="rb1" checked="checked">
                  Yes,  check <strong><%=startNo %></strong> printed correctly.</td>				
                </tr>
                
                <tr>
                  <td align="left">&nbsp;</td>
                  <td height="22" align="left"><input name="rb1" type="radio" id="rb2" >
                  I didn't print check <strong><%=startNo %></strong>.</td>				
                </tr>
                <tr>
                  <td align="left">&nbsp;</td>
                  <td height="13" align="left">&nbsp;</td>
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
				document.form1.action="print_check_ok.asp?ok=yes"
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