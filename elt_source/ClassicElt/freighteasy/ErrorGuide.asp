<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <meta content="text/html; charset=iso-8859-1" http-equiv="Content-Type" />
    <link href="../CSS/elt.css" rel="stylesheet" type="text/css">
    <style type="text/css">
<!--
body {
	margin-left: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
	margin-top: 0px;
}
.style2 {color: #336699}
.style3 {color: #244B7B}
-->
    </style>
    <title>ErrorGuide</title>

    <script language='javascript'>
window.name = 'ErrorGuide';
    </script>

</head>
<% 
DIM ArrMsg
s = Request.QueryString("p") 
ArrMsg = split(s,"^")
%>

<script language="javascript">
function myLoad() {
}

function myClose() {
window.close();
}

function myUnLoad() {
var rVal = document.fShowModal.hReturnValue.value;

	if (rVal != '') 
	{
	window.returnValue = rVal;
	}
	else
	{
	window.returnValue = '';
	}
}

function cancel() 
{
    document.fShowModal.hReturnValue.value = 'cancel';
    myClose();
}

function goFix() 
{
    document.fShowModal.hReturnValue.value = 'fix';
    myClose();
}

function go() 
{
    document.fShowModal.hReturnValue.value = 'go';
    myClose();
}
</script>

<body onload="javascript:myLoad();" onunload="javascript:myUnLoad();">
    <form action="/Freighteasy/ErrorGuide.asp" method="post" name="fShowModal">
        <input name="hReturnValue" type="hidden" width="1px" />
        <table align="center" bgcolor="#FFFFF9" border="0" cellpadding="0" cellspacing="0"
            height="225" width="500">
            <tr>
                <td class="bodycopy" height="90">
                    <table align="center" border="0" cellpadding="0" cellspacing="0" class="bodycopy"
                        width="100%">
                        <tr>
                            <td align="center" class="bodycopy" valign="middle" width="79">
                                &nbsp; &nbsp; &nbsp;
                                <img height="50" src="/iff_main/Images/error.gif" width="50"></td>
                            <td bgcolor="b5d0f1" width="1">
                            </td>
                            <td width="20">
                            </td>
                            <td class="bodycopy" width="300">
                                <strong>Error has occurred during your login! </strong>
                                <br />
                                <br />
                                If this problem persists, please contact support center or e-mail to <a href="mailto:support@e-logitech.net">
                                    support@e-logitech.net</a>.</td>
                        </tr>
                    </table>
                </td>
            </tr>
			<tr><td><table width="100%" border="0" cellspacing="0" cellpadding="0">
                <tr>
                    <td width="123">&nbsp;</td>
					<% if NOT ArrMsg(0) = "N" then 'System Connection Error %>
                    <td width="75%"><span class="bodycopy style3">System Connection Error was occured!</span></td>
					<% end if %>
                    </tr>
                <tr>
                    <td>&nbsp;</td>
		            <% if NOT ArrMsg(1) = "N" then 'Account No. or ID Error %>					
                    <td><span class="bodycopy style3">Your Account No. or ID does not exist ! </span></td>
					<% end if %>
                    </tr>
                <tr>
                    <td>&nbsp;</td>
		            <% if NOT ArrMsg(2) = "N" then 'Password Error %>					
                    <td><span class="bodycopy style3">Invalid Password. Please use a correct password and try again. </span></td>
					<% end if %>
                    </tr>
<!--					
                <tr>
                    <td>&nbsp;</td>
		            <% 'if NOT ArrMsg(3) = "N" then 'ActiveX Error %>					
                    <td><span class="bodycopy style2">ActiveX Error </span></td>
					<% 'end if%>
                    </tr>
-->					
            </table></td>
			</tr>
            
            <tr>
              <td align="center">
                    <%if ArrMsg(0) = "Y" or ArrMsg(1) = "Y" or ArrMsg(2) = "Y" then%>
                    <input id="bClose" class="bodycopy" onclick="javascript:window.close();" type="button"
                        value="Close" />
                    <% else %>
                    <input id="bGo" class="bodycopy" onclick="javascript:go();" type="button" value="Go" />
                    <input id="bCancel" class="bodycopy" onclick="javascript:cancel();" type="button"
                        value="Cancel" />
                    <% end if %>
                    <%if ArrMsg(3) = "Y" then%>
                    <input id="bFix" class="bodycopy" onclick="javascript:goFix();" type="button" value="Fix" style="visibility:hidden"/></td>
                <% end if %>
            </tr>
        </table>
    </form>
</body>

<script language="vbscript">

Sub Test()
	document.fShowModal.action="ErrorGuide.asp"
	document.fShowModal.method="POST"
	Document.fShowModal.target=window.name
	Document.fShowModal.submit()
	
End Sub

--->
</script>

</html>
