<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%if int(request("iMiliSecs")) > 0 then
    response.Write "<script>"
    response.Write "setTimeout('this.close();',"& request("iMiliSecs") &");"
    response.Write "</script>"
  end if
%>
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>System Message</title>
</head>
<body bgcolor="#d4d0c8" onblur="window.focus();" bottommargin="0" topmargin="0" leftmargin="0" rightmargin="0">
<!--url's used in the movie-->
<!--text used in the movie-->
<div align="center">
<table border="0"><tr><td height="5px"></td></tr></table>
<object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000" codebase="http://download.macromedia.com/pub/shockwave/cabs/flash/swflash.cab#version=7,0,0,0" width="111" height="46" id="Processing" align="middle">
<param name="allowScriptAccess" value="sameDomain" />
<param name="movie" value="Processing.swf" />
<param name="quality" value="high" />
<param name="bgcolor" value="#F" />
<embed src="Processing.swf" quality="high" bgcolor="#d4d0c8" width="111" height="46" name="Processing" align="middle" allowScriptAccess="sameDomain" type="application/x-shockwave-flash" pluginspage="http://www.macromedia.com/go/getflashplayer" />
</object>
</div>
<table border="0"><tr><td height="5px"></td></tr></table>
<div style="width:window.width; font-family: Verdana, Arial, Helvetica, sans-serif; font-size: 12px; font-weight: bold; color: #000000; text-align:center;">
  <%  response.Write request("sMessage") %>
</div>
</body>
</html>
