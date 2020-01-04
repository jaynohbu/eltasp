<%

    Dim vEmail, vPassword, vSetupURL, vEmailStr, oMail

    vEmail = Request("Request_Email")
    vPassword = Request("Request_Password")
    vSetupURL = "http://" & Request.ServerVariables("HTTP_HOST") _
        & "/IFF_MAIN/Authentication/SetupLogin.aspx?sid=" & Request("hFreeSessionID")

	vEmailStr = "<html xmlns='http://www.w3.org/1999/xhtml><head><meta http-equiv='Content-Type' content='text/html; charset=iso-8859-1' /><title>Untitled Document</title><style type='text/css'><!--.style3 {	font-family: Verdana, Arial, Helvetica, sans-serif;	font-size: 9px;}--></style></head><body><p class='style3'><strong>Account Request Information</strong></p>"
	vEmailStr = vEmailStr & "<p class='style3'>" & "You have requested a account from FreightEasy. Following is information that you provided to us.<br />"
	vEmailStr = vEmailStr & "Please, use this link to access your account request at any time.<br /><a href='" & vSetupURL & "'>" & vSetupURL & "</a></p>"
	vEmailStr = vEmailStr & "<p class='style3'>Eamil: " & vEmail & "<br /> " & "Password: " & vPassword & "</p>"
	vEmailStr = vEmailStr & "<table width='100%' border='0' cellspacing='0' cellpadding='0'><tr><td align='left' valign='bottom'><span class='style3'>This message was sent by E-LOGISTICS TECHNOLOGY</span></td><td align='right' valign='top'><a href='http://e-logitech.net' target='_blank'><img src='http://www.e-logitech.net/elt_email/images/powered_logo.gif' width='123' height='50' border='0' /></a></td></tr></table><span class='style3'><br /></span></body></html>"

    Set oMail = Server.CreateObject("Persits.MailSender")
    oMail.Host = ""
	oMail.IsHTML = True
	oMail.Body = vEmailStr
	oMail.Subject = "Account Request Information"

	oMail.From = "info@e-logitech.net"
	oMail.FromName = "FreightEasy Account Setup"		
	oMail.AddAddress vEmail
	'// oMail.AddCC "info@e-logitech.net"

'////////////////////////////////////////////////////////////
    On Error Resume Next:
    oMail.Send
	error_num = Err.Number
	Set Mail = Nothing
			
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>FreightEasy Home</title>
    <style type="text/css">
</style>

    <script type="text/JavaScript">

        function viewPop(Url) {
            var strJavaPop = "";
            strJavaPop = window.open(Url,'popupNew','staus=0,titlebar=0,toolbar=1,menubar=1,scrollbars=1,resizable=1,location=0,width=900,height=600,hotkeys=0');
            strJavaPop.focus();
        }

        function MM_preloadImages() { //v3.0
            var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
            var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
            if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
        }

        function goIFF() {
            window.location = '/freighteasy/index.aspx';
        }

    </script>

    <link href="css/style_freighteasy.css" rel="stylesheet" type="text/css" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <style type="text/css">
        .style3 {font-family: Verdana, Arial, Helvetica, sans-serif}
        .style5 {font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: bold; }
    </style>
</head>
<body onload="MM_preloadImages('images/button_elthome_over.gif')">
    <table width="100%" border="0" cellpadding="0" cellspacing="0"">
        <tr>
            <td width="100%" align="left" valign="top">
                <table width="100%" height="42" border="0" cellpadding="0" cellspacing="0">
                    <tr>
                        <td>
                            <% Server.Execute("/Include/main_menu.htm")%>
                        </td>
                    </tr>
                </table>
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td height="1" colspan="2" bgcolor="#a4a3a7">
                        </td>
                    </tr>
                    <tr>
                        <td bgcolor="#d5d6e1">
                            <table width="100%" height="0" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td width="3%" height="16" align="left" valign="middle">
                                    </td>
                                    <td align="left" valign="bottom" class="breadcrumb">
                                        <a href="index.aspx">Home</a> / <a href="index.aspx">Product</a> / Account Setup
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" valign="top">
                                        &nbsp;</td>
                                    <td align="left" valign="bottom">
                                        <a href="index.aspx">
                                            <img src="images/product_logo.gif" width="121" height="37" border="0" onclick="javascript:goIFF();" /></a><img
                                                src="images/spacer.gif" width="276" height="1" /></td>
                                </tr>
                                <tr>
                                    <td height="1" colspan="2" align="left" valign="top">
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td bgcolor="#d5d6e1">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td height="1" colspan="2" bgcolor="#a4a3a7">
                        </td>
                    </tr>
                    <tr>
                        <td width="66%" align="left" valign="top">
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tr>
                                    <td height="24" align="left" valign="top" bgcolor="#FFFFFF">
                                        &nbsp;</td>
                                    <td colspan="2" align="right" valign="top" bgcolor="#FFFFFF">
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td width="3%" height="29" align="left" valign="top" bgcolor="#FFFFFF">
                                    </td>
                                    <td width="94%" align="left" valign="top" bgcolor="#FFFFFF">
                                    </td>
                                    <td width="3%" align="left" valign="top" bgcolor="#FFFFFF">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                    </td>
                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                        <p>
                                            <a href="<%=vSetupURL %>">Goto FreightEasy™ Setup Wizard</a></p>
                                    </td>
                                    <td align="left" valign="top" bgcolor="#FFFFFF">
                                    </td>
                                </tr>
                            </table>
                        </td>
                        <td rowspan="2" width="34%" align="left" valign="top">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="70%" align="left" valign="top" bgcolor="#edf2f8">
                                        <div id="infospace">
                                        </div>
                                        <br />
                                    </td>
                                    <td width="30%" align="left" valign="top" bgcolor="#edf2f8">
                                        &nbsp;</td>
                                </tr>
                                <tr>
                                    <td height="1" colspan="2" align="left" valign="top" bgcolor="#b6b4ba">
                                    </td>
                                </tr>
                                <tr>
                                    <td align="left" valign="top">
                                        <div id="navleftbar">
                                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                                <tr>
                                                    <td>
                                                        <ul id="mainnavheader">
                                                            <li><a href="#">FreightEasy<span class="body">&trade;</span> Home</a></li>
                                                        </ul>
                                                        <ul id="mainnav">
                                                            <li><a href="introduction.asp">Introduction</a></li>
                                                            <li><a href="why_fe.asp">Why FreightEasy</a></li>
                                                            <li><a href="features.asp">Features</a></li>
                                                        </ul>
                                                        <ul id="mainnavbottom">
                                                            <li><a href="faqs.asp">FAQs</a></li>
                                                        </ul>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td>
                                                        <ul id="mainnavheader">
                                                            <li><a href="#">Quick Links </a></li>
                                                        </ul>
                                                        <ul id="mainnav">
                                                            <li><a href="account_setup.asp">Account Request </a></li>
                                                            <li><a href="getting_tips.asp">Getting Started Tips </a></li>
                                                            <li><a href="../support.asp">Support</a></li>
                                                        </ul>
                                                    </td>
                                                </tr>
                                            </table>
                                            <br />
                                            <br />
                                        </div>
                                    </td>
                                    <td align="left" valign="top">
                                        &nbsp;</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td align="left" valign="bottom">
                            &nbsp;</td>
                    </tr>
                    <tr>
                        <td height="1" colspan="2" bgcolor="#a4a3a7">
                        </td>
                    </tr>
                    <tr>
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <td width="3%" height="48">
                                        &nbsp;</td>
                                    <td width="94%" align="left" valign="middle">
                                        <% Server.Execute("/Include/siteinfo.html")%>
                                    </td>
                                    <td width="3%">
                                        &nbsp;</td>
                                </tr>
                            </table>
                        </td>
                        <td align="left" valign="top">
                        </td>
                    </tr>
                </table>
                <br />
                <br />
                <br />
                <br />
                <br />
            </td>
        </tr>
    </table>
</body>
</html>
