<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" 
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>FreightEasy Home</title>
    <link href="css/style_freighteasy.css" rel="stylesheet" type="text/css" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <style type="text/css">
        .style3 {font-family: Verdana, Arial, Helvetica, sans-serif}
        .style5 {font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: bold; }
    </style>

    <script type="text/javascript" language="javascript" src="/IFF_MAIN/ASP/ajaxFunctions/ajax.js"></script>

    <script type="text/JavaScript">
		
        function viewPop(Url) {
            var strJavaPop = "";
            strJavaPop = window.open(Url,'popupNew','staus=0,titlebar=0,toolbar=1,menubar=1,scrollbars=1,resizable=1,location=0,width=900,height=600,hotkeys=0');
            strJavaPop.focus();
        }

        function GoMain() {
            __doPostBack("btnGoMain", "");   		
        }

        function MM_preloadImages() { //v3.0
            var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
            var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
            if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
        }

        function goIFF() 
        {
            window.location = '/freighteasy/index.aspx';
        }

    </script>

    <script type="text/jscript" id="FORM MACHINE SCRIPTS">

        function ValidateCUItem(item, name, validate_mail)
        {
            if (document.AccountSetup.elements[item]) {
                if (document.AccountSetup.elements[item].value.length < 1)
                {  
                    alert("You must enter a value for " + name);
                    document.AccountSetup.elements[item].focus();
                return false;
                }
                if (validate_mail)
                {
                    var emailFilter=/^.+@.+\..{2,3}$/;
                    var illegalChars= /[\(\)\<\>\,\;\:\\\/\"\[\]]/;
                    var strng = document.AccountSetup.elements[item].value;
                    if (!(emailFilter.test(strng)))
                    { 
                        alert("You have entered an invalid email address.");
                        document.AccountSetup.elements[item].focus();
                        return false;
                    }
                    if (strng.match(illegalChars))
                    { 
                        alert("Your email address contains invalid characters.");
                        document.AccountSetup.elements[item].focus();
                        return false;
                    }
                }
            }
            return true;
        }
        
        function ValidateCUForm()
        {
            if (!ValidateCUItem("Request_Email", "Email", true)) return false;
            if (!ValidateCUItem("Request_Password", "Password", false)) return false;
            
            document.getElementById("hFreeSessionID").value = createSetup();
            
            if(document.getElementById("hFreeSessionID").value == "exists"){
                alert("Email address is alreay in our database!");
                return false;
            }
			if(document.getElementById("hFreeSessionID").value == "error"){
				alert("Unknown error has occured!");
                return false;
			}
            return true;;
        }
        
        function createSetup()
        {
            if (window.ActiveXObject) {
                try {
                    xmlHTTP = new ActiveXObject("Msxml2.XMLHTTP");
                } catch(error) {
                    try {
                        xmlHTTP = new ActiveXObject("Microsoft.XMLHTTP");
                    } catch(error) { return ""; }
                }
            } 
            else if (window.XMLHttpRequest) {
                xmlHTTP = new XMLHttpRequest();
            } 
            else { return ""; }

			var vEmail = document.getElementById("Request_Email").value;
			var vPassword = document.getElementById("Request_Password").value;
			if(vEmail != "" && vPassword != ""){
				var url= "./statistics/createSetupSession.asp?email=" 
					+ document.getElementById("Request_Email").value 
					+ "&password=" + document.getElementById("Request_Password").value;
			
				xmlHTTP.open("GET",url,false); 
				xmlHTTP.send();
				return xmlHTTP.responseText; 
			}
        }
    </script>

</head>
<body onload="MM_preloadImages('images/button_elthome_over.gif')">
    <form name="AccountSetup" action="account_thank_2.asp" method="post">
        <input type="hidden" id="hFreeSessionID" name="hFreeSessionID" />
        <table width="100%" border="0" cellpadding="0" cellspacing="0"">
            <tr>
                <td width="100%" align="left" valign="top">
                    <table width="100%" height="42" border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <td>
                                <% Server.Execute("/Include/main_menu.htm") %>
                            </td>
                        </tr>
                    </table>
                    <table width="100%" border="0" cellspacing="0" cellpadding="0">
                        <tr>
                            <td height="1" colspan="2" bgcolor="#a4a3a7">
                            </td>
                        </tr>
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
                                <h1>
                                    FreightEasy Account Request</h1>
                            </td>
                            <td width="3%" align="left" valign="top" bgcolor="#FFFFFF">
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" bgcolor="#FFFFFF">
                            </td>
                            <td align="left" valign="top" bgcolor="#FFFFFF">
                                <table border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td height="18" align="left" valign="bottom">
                                            E-mail Address<span class="style3"><strong><font color="d02d17">*</font></strong></span></td>
                                        <td style="width: 4px">
                                        </td>
                                        <td align="left" valign="bottom">
                                            Password<span class="style3"><strong><font color="d02d17">*</font></strong></span></td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="top" class="bodycopy">
                                            <input name="Request_Email" id="Request_Email" class="formfield" size="40" /></td>
                                        <td style="width: 4px">
                                        </td>
                                        <td align="left" valign="top" class="bodycopy">
                                            <input type="password" name="Request_Password" id="Request_Password" class="formfield"
                                                size="20" /></td>
                                    </tr>
                                    <tr>
                                        <td style="height:20px"></td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="top" colspan="2">
                                            <input name="Input" type="submit" class="formfield" onclick="return ValidateCUForm();"
                                                value="Request Submit" size="Submit" />
                                            </td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                    </tr>
                                </table>
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
                                <div id="navleftbar" style="height: 700px">
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
                                                    <li><a href="account_setup.asp">Account Request</a></li>
                                                    <li><a href="getting_tips.asp">Getting Started Tips </a></li>
                                                    <li><a href="../support.asp">Support</a></li>
                                                </ul>
                                            </td>
                                        </tr>
                                    </table>
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
                                <% Server.Execute("/Include/siteinfo.html") %>
                            </td>
                            <td width="3%">
                                &nbsp;</td>
                        </tr>
                    </table>
                </td>
                <td align="left" valign="top">
                    <asp:button id="btnGoMain" runat="server" onclick="btnGoMain_Click" width="0px" height="0px"
                        causesvalidation="False" />
                    <asp:linkbutton id="LinkButton1" runat="server" height="0px" width="0px"></asp:linkbutton>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
