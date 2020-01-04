
<!--  #INCLUDE FILE="../include/transaction.txt" -->
<% 
    Option Explicit
    Response.CharSet = "UTF-8"
    Session.CodePage = "65001"
%>
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Select a Printer</title>
<link href="../css/elt_css.css" rel="stylesheet" type="text/css">
   
<script language='javascript'>
window.name = 'find_print';
</script>
<!--  #INCLUDE FILE="connection.asp" -->
<!--  #INCLUDE FILE="header.asp" -->
</head>

<%

DIM strName,PostBack

	PostBack = Request.QueryString("PostBack")
	if isnull(PostBack) then
		PostBack = true
	end if	
	
	strName   = Request.QueryString("l")
	if isnull(strName) then
		strName = ""
	end if

%>
<script language="javascript" src="elt_print_functions.js"></script>
<script language="javascript">
function GetPrinterList() {
var printList = EltClient.GET_PRINTER_LIST();
var aPrintList = printList.split('^^^^^^^^^^');
var tmpHtml = '';
			if (aPrintList.length > 1) {
				for(var i=0;i<aPrintList.length;i++)
				{
					if (aPrintList[i] != '') {
						tmpHtml += '<option>' + aPrintList[i] + '</option>'
					}
				}
				createSelectMulti('Printer',tmpHtml,'300px','200px');
				setSelect("lst_Printer","<%=replace(strName,"\","\\")%>");
				getPrinterInfo("<%=replace(strName,"\","\\")%>");
			}	
}
function getPrinterInfo(pPrinter) {
	if(pPrinter != '') {
		var server_name = EltClient.GET_PRINTER_SERVER_NAME(pPrinter);
		var share_name  = EltClient.GET_PRINTER_SHARE_NAME(pPrinter);
		var local_port = EltClient.GET_PRINTER_PORT(pPrinter);
		var p_path = '';
		
		if (share_name != '') {
			if(server_name != '') {
				p_path = server_name + '\\' + share_name;		
			} else {
				p_path = '\\\\' + '127.0.0.1' + '\\' + share_name;		
			}
//			local_port = '';	
		}
		document.getElementById('txt_printer_name').value = pPrinter;
		document.getElementById('txt_printer_svr').value  = p_path;
		document.getElementById('txt_printer_port').value = local_port;
	}
}
</script>
<body link="336699" vlink="336699" leftmargin="0" topmargin="0" marginwidth="0" marginheight="0" onLoad="javascript:GetPrinterList()">
<table width="100%" border="0" align="center" cellpadding="0" cellspacing="0"bgcolor="DDDDED">
  <tr> 
    <td> 
     <form name=form1 method="post">
       <table width="100%" border="0" cellpadding="3" cellspacing="0" bordercolor="DDDDED" class="border1px">
          <tr bgcolor="E5D4E3"> 
            <td height="8" colspan="5" align="center" valign="top" bgcolor="DDDDED" class="bodyheader">*  Please Select a Printer </td>
          </tr>
		            <tr align="left" valign="middle" bgcolor="DDDDED"> 
            <td height="1" class="bodyheader"></td>
          </tr>
                    
                    <tr align="left" valign="middle" bgcolor="f3f3f3">
                      <td height="22" align="center" id="Printer" colspan="2">&nbsp;</td>
                    </tr>
		            <tr align="center" bgcolor="D5E8CB">
		              <td height="20" valign="middle" bgcolor="FFFFFF" class="bodyheader" >Name : </td>
		              <td height="20" valign="middle" align="left" bgcolor="FFFFFF" class="bodycopy" width="300px"><input type="text" name="txt_printer_name" class="bodycopy" style="width: 100%; text-align:left; border-style:none; background-color:#f3f3f3" readonly="true"/></td>
          </tr>
		            <tr align="center" bgcolor="D5E8CB">
		              <td height="20" valign="middle" bgcolor="FFFFFF" class="bodyheader" >Port : </td>
		              <td height="20" valign="middle" align="left" bgcolor="FFFFFF" class="bodycopy"><input type="text" name="txt_printer_port" class="bodycopy" style="width: 100%; text-align:left; border-style:none; background-color:#f3f3f3" readonly="true"/></td>
          </tr>
		            <tr align="center" bgcolor="D5E8CB">
		              <td height="20" valign="middle" bgcolor="FFFFFF" class="bodyheader" > Path : </td>
		              <td height="20" valign="middle" align="left" bgcolor="FFFFFF" class="bodycopy"><input type="text" name="txt_printer_svr"  class="bodycopy" style="width: 100%; text-align:left; border-style:none; background-color:#f3f3f3" readonly="true"/></td>
          </tr>
		            
          <tr align="center" bgcolor="D5E8CB"> 
            <td height="20" valign="middle" bgcolor="DDDDED" class="bodycopy" colspan="2">
            <input type="button" class="bodycopy" id=Button2 style="WIDTH: 100px;" value='Ok' name="Ok" onClick="okClick();">
            <input type="button" class="bodycopy" id=Button3 style="WIDTH: 100px;" onClick="javascript:window.close();" value="Cancel" name="CloseMe"></td>
          </tr>					
        </table>
      </form></td>
  </tr>
</table>
</body>
<script type="text/jscript">
function trim(sourceString) { return sourceString.replace(/(?:^\s+|\s+$)/ig, ""); }
function okClick() {

	var	pPrinter = 	document.getElementById('txt_printer_name').value;
	var p_path 	 = 	document.getElementById('txt_printer_svr').value;
	var local_port = document.getElementById('txt_printer_port').value;
	if (trim(pPrinter) == '') {
		alert('Please select a Printer');
		return false;
	}	
	var retVal = pPrinter + "^^^" + p_path + "^^^" + local_port.replace(':','');
	closeReturn(retVal);
}
function getPrinterInfo_sel(oSelect) {
	var pPrinter = oSelect.options[ oSelect.options.selectedIndex ].text;
	getPrinterInfo(pPrinter);
}
function closeReturn(s) 
{
	
	window.returnValue = replace_back_slash(s);
	window.close();
}
function replace_back_slash(s) {
//while(s.indexOf("\\") != -1) { s = s.replace('\\','/');	}	
return s;
}
</script>
</html>
