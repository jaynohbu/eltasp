<!--  #INCLUDE FILE="../include/transaction.txt" -->
<html>
<head>
<title>Print Check</title>
<meta http-equiv="Content-Type" content="text/html; charset=windows-1252">
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
    <script src="/Scripts/jquery-1.7.1.min.js"></script>
</head>
<%
DIM startNo,endNo,ok,nextCheckNo

startNo = Request.QueryString("startCheckNo")
endNo = Request.QueryString("endCheckNo")

ok = Request.QueryString("ok")
nextCheckNo = Request.QueryString("nextCheck")

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
                  Yes, checks <strong><%=startNo %></strong> through <strong><%=endNo %></strong> printed correctly.</td>				
                </tr>
                <tr>
                  <td align="left">&nbsp;</td>
                  <td height="22" align="left"><input name="rb1" type="radio" id="rb2" >
                  No, some checks did not print correctly. First incorrectly printed check : 
                    <select name="lstCheckNo" size="1" class="smallselect" id="lstCheckNo" style="WIDTH: 100px"  onChange="rbChange()">
						<option value="0">Select One</option>
						<% for i=startNo to endNo %>
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
      <div align="center"><input name="OK" type="button" id="OK" value="OK" onClick="OkClick()"  style="width:70px">
      </div>
		
</form>
</body>
<script type="text/javascript">
function rbChange(){
    document.form1.rb1.item(1).checked = true;
}

function OkClick(){

    if (document.form1.rb1.item(0).checked) {
        // if ($.browser.chrome) { alert( window.parent.ModalHandle.Modal); return; }
      
        window.top.close();
        window.returnValue = 0;
    }
    else if (document.form1.rb1.item(1).checked) {
        nextCheck = $("#lstCheckNo").val();
      //  if ($.browser.chrome) { self.close(); window.parent.ModalHandle.Modal.close(); return; }
        window.top.close();
        window.returnValue = nextCheck;
    }
    else {
       // if ($.browser.chrome) { self.close(); window.parent.ModalHandle.Modal.close(); return; }
        window.top.close();
        window.returnValue =- 1;
    }
      
}

function CancelClick(){
  
    window.top.close();
    return -1;
}
</script>

</html>