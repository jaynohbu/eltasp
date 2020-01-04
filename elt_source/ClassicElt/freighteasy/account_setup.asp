<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>FreightEasy Home</title>

    <script type="text/JavaScript">

	function ValidateCUForm()
	{
		if (!ValidateCUItem("Request_Name", "Name", false)) return false;
		if (!ValidateCUItem("Request_Company_Name", "Company Name", false)) return false;
		if (!ValidateCUItem("Request_Email", "Email", true)) return false;
		return true;
	}

	function ForwardToOnlineSetup()
	{
		viewPop('/IFF_MAIN/OnlineRequest/NewAccount.aspx');
		window.history.go(-1);
	}

	function viewPop(Url) {
		var strJavaPop = "";
		strJavaPop = window.open(Url,"popupNew","top=0,left=0,staus=0,titlebar=0,toolbar=1,menubar=1,scrollbars=1,resizable=1,location=0,width=850,height=550,hotkeys=0");
		strJavaPop.focus();
	}

	ForwardToOnlineSetup();


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

    <link href="css/style_freighteasy.css" rel="stylesheet" type="text/css" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <style type="text/css">

	.style3 {font-family: Verdana, Arial, Helvetica, sans-serif}
	.style5 {font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: bold; }

	</style>
</head>

<script language="JavaScript" id="FORM MACHINE SCRIPTS">


function ValidateCUItem(item, name, validate_mail)
{
  if (document.AccountSetup.elements[item]) {
    if (document.AccountSetup.elements[item].value.length < 1)
    {  alert("You must enter a value for " + name);
      document.AccountSetup.elements[item].focus();
      return false;
    }
    if (validate_mail)
    {
      var emailFilter=/^.+@.+\..{2,3}$/;
      var illegalChars= /[\(\)\<\>\,\;\:\\\/\"\[\]]/;
      var strng = document.AccountSetup.elements[item].value;
      if (!(emailFilter.test(strng)))
      { alert("You have entered an invalid email address.");
        document.AccountSetup.elements[item].focus();
        return false;
      }
      if (strng.match(illegalChars))
      { alert("Your email address contains invalid characters.");
        document.AccountSetup.elements[item].focus();
        return false;
      }
    }
  }
  return true;
}

</script>

<body onload="MM_preloadImages('images/button_elthome_over.gif'); ">
    <form name="AccountSetup" action="account_thank.asp" method="post">
        
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
                                <h1>
                                    Request Free Trial Account Setup</h1>
                            </td>
                            <td width="3%" align="left" valign="top" bgcolor="#FFFFFF">
                            </td>
                        </tr>
                        <tr>
                            <td align="left" valign="top" bgcolor="#FFFFFF">
                            </td>
                            <td align="left" valign="top" bgcolor="#FFFFFF">
                                <p>
                                    Remember, FreightEasy is web-based, so there are no special hardware requirements
                                    and you don't have to wait on a software installation. Once we setup your account
                                    with some basic info, you can log on immediately and start using the system. The
                                    trial is a full version of our system with some placeholder data entered, so you
                                    will get a realistic feel. Any data you enter of your own will be erased at the
                                    end of the trial period, or transferred to your new account if you decide to buy
                                    our system. The trial period will last one week. Please fill out the questionnaire
                                    below and we will get back to you with your own unique user name and password. This
                                    questionnaire is intended to help us learn more about you, to help us improve FreightEasy
                                    and to help us better serve our customers. It will also provide us with some of
                                    the basic information we need to set up your trial account.</p>
                                <p>
                                    <input id="Redirect_URL" type="hidden" value="freighteasy/account_thank.asp" name="Redirect_URL" />
                                    <input id="MailToName" type="hidden" value="Andy" name="MailToName" />
                                    <input id="MailToAddress" type="hidden" value="info@e-logitech.net" name="MailToAddress" /></p>
                                <p>
                                    <span class="style5"><font color="d02d17">*</font></span> Required field</p>
                                <table width="90%" border="0" cellpadding="0" cellspacing="0">
                                    <tr>
                                        <td width="386" height="40" align="left" valign="top">
                                            Name<span class="style5"><font color="d02d17">*</font></span><br />
                                            <input name="Request_Name" size="30" /></td>
                                    </tr>
                                    <tr>
                                        <td height="40" align="left" valign="top">
                                            Title<br />
                                            <input name="Request_Title" class="formfield" size="30" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="40" align="left" valign="top">
                                            Company Name<span class="style5"><font color="d02d17">*</font></span><font color="d02d17"><br />
                                            </font>
                                            <input name="Request_Company_Name" class="formfield" size="30" /></td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="top">
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                <tr>
                                                    <td height="30" align="left" valign="top">
                                                        Address<br />
                                                        <input name="Request_Address" class="formfield" size="34" /></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="top">
                                                        <table width="100%" height="46" border="0" cellpadding="0" cellspacing="0">
                                                            <tr>
                                                                <td width="19%" height="18" align="left" valign="bottom">
                                                                    City</td>
                                                                <td width="12%" align="left" valign="bottom">
                                                                    State</td>
                                                                <td width="69%" align="left" valign="bottom">
                                                                    Zip</td>
                                                            </tr>
                                                            <tr>
                                                                <td align="left" valign="top" class="bodycopy">
                                                                    <input name="Request_City" class="formfield" size="14" /></td>
                                                                <td align="left" valign="top" class="bodycopy">
                                                                    <input name="Request_State" class="formfield" size="5" /></td>
                                                                <td align="left" valign="top" class="bodycopy">
                                                                    <input name="Request_Zip" class="formfield" size="8" /></td>
                                                            </tr>
                                                        </table>
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="40" align="left" valign="top">
                                                        E-mail Address<span class="style3"><strong><font color="d02d17">*</font></strong></span><br />
                                                        <input name="Request_Email" class="formfield" size="34" />
                                                        &nbsp; &nbsp;
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td height="40" align="left" valign="top">
                                                        Phone Number<br />
                                                        <input name="Request_Phone_Number" class="formfield" size="20" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="20" align="left" valign="top">
                                            <br />
                                            Please select features most important to you.<br />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="20" align="left" valign="top">
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                                                <tr>
                                                    <td width="194" height="19" align="left" valign="top" bgcolor="#CCCCCC" class="bodycopy_indent">
                                                        &nbsp;</td>
                                                    <td bgcolor="#CCCCCC" class="bodycopy_indent">
                                                        Very Important
                                                    </td>
                                                    <td bgcolor="#CCCCCC" class="bodycopy_indent">
                                                        Somewhat Important</td>
                                                    <td bgcolor="#CCCCCC" class="bodycopy_indent">
                                                        Not Important
                                                    </td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle" class="bodycopy_indent">
                                                        Ease of startup
                                                    </td>
                                                    <td align="center" valign="middle">
                                                        <input type="radio" name="Request_EasyStartup" value="Very Important" />
                                                    </td>
                                                    <td align="center" valign="middle">
                                                        <input type="radio" name="Request_EasyStartup" value="Somewhat Important" /></td>
                                                    <td align="center" valign="middle">
                                                        <input type="radio" name="Request_EasyStartup" value="Not Important" /></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle" bgcolor="#EFEFEF" class="bodycopy_indent">
                                                        Low cost of startup
                                                    </td>
                                                    <td align="center" valign="middle" bgcolor="#EFEFEF">
                                                        <input type="radio" name="Request_LowCost" value="Very Important" />
                                                    </td>
                                                    <td align="center" valign="middle" bgcolor="#EFEFEF">
                                                        <input type="radio" name="Request_LowCost" value="Somewhat Important" /></td>
                                                    <td align="center" valign="middle" bgcolor="#EFEFEF">
                                                        <input type="radio" name="Request_LowCost" value="Not Important" /></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle" class="bodycopy_indent">
                                                        Low monthly fee
                                                    </td>
                                                    <td align="center" valign="middle">
                                                        <input type="radio" name="Request_LowFee" value="Very Important" />
                                                        <br />
                                                    </td>
                                                    <td align="center" valign="middle">
                                                        <input type="radio" name="Request_LowFee" value="Somewhat Important" /></td>
                                                    <td align="center" valign="middle">
                                                        <input type="radio" name="Request_LowFee" value="Not Important" /></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle" bgcolor="#EFEFEF" class="bodycopy_indent">
                                                        Mobility of system
                                                    </td>
                                                    <td align="center" valign="middle" bgcolor="#EFEFEF">
                                                        <input type="radio" name="Request_Mobility" value="Very Important" />
                                                    </td>
                                                    <td align="center" valign="middle" bgcolor="#EFEFEF">
                                                        <input type="radio" name="Request_Mobility" value="Somewhat Important" /></td>
                                                    <td align="center" valign="middle" bgcolor="#EFEFEF">
                                                        <input type="radio" name="Request_Mobility" value="Not Important" /></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle" class="bodycopy_indent">
                                                        Accounting features
                                                    </td>
                                                    <td align="center" valign="middle">
                                                        <input type="radio" name="Request_Accounting" value="Very Important" /></td>
                                                    <td align="center" valign="middle">
                                                        <input type="radio" name="Request_Accounting" value="Somewhat Important" /></td>
                                                    <td align="center" valign="middle">
                                                        <input type="radio" name="Request_Accounting" value="Not Important" /></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle" bgcolor="#EFEFEF" class="bodycopy_indent">
                                                        AMS/AES connectivity
                                                    </td>
                                                    <td align="center" valign="middle" bgcolor="#EFEFEF">
                                                        <input type="radio" name="Request_AMSAES" value="Very Important" /></td>
                                                    <td align="center" valign="middle" bgcolor="#EFEFEF">
                                                        <input type="radio" name="Request_AMSAES" value="Somewhat Important" /></td>
                                                    <td align="center" valign="middle" bgcolor="#EFEFEF">
                                                        <input type="radio" name="Request_AMSAES" value="Not Important" /></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle" class="bodycopy_indent">
                                                        Design of system/Workflow
                                                    </td>
                                                    <td align="center" valign="middle">
                                                        <input type="radio" name="Request_DesignSystem" value="Very Important" /></td>
                                                    <td align="center" valign="middle">
                                                        <input type="radio" name="Request_DesignSystem" value="Somewhat Important" /></td>
                                                    <td align="center" valign="middle">
                                                        <input type="radio" name="Request_DesignSystem" value="Not Important" /></td>
                                                </tr>
                                                <tr>
                                                    <td align="left" valign="middle" bgcolor="#EFEFEF" class="bodycopy_indent">
                                                        Technical support/Customer service
                                                    </td>
                                                    <td align="center" valign="middle" bgcolor="#EFEFEF">
                                                        <input type="radio" name="Request_Support_Service" value="Very Important" /></td>
                                                    <td align="center" valign="middle" bgcolor="#EFEFEF">
                                                        <input type="radio" name="Request_Support_Service" value="Somewhat Important" /></td>
                                                    <td align="center" valign="middle" bgcolor="#EFEFEF">
                                                        <input type="radio" name="Request_Support_Service" value="Not Important" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="20" align="left" valign="top">
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td height="40" align="left" valign="top">
                                            What Freight Forwarding System are you currently using?<br />
                                            <input name="Request_Current_System" class="formfield" size="30" /></td>
                                    </tr>
                                    <tr>
                                        <td height="40" align="left" valign="top">
                                            How many employees do you have?<br />
                                            <input name="Request_Employee_Number" class="formfield" size="6" /></td>
                                    </tr>
                                    <tr>
                                        <td height="40" align="left" valign="top">
                                            How did you hear about us?<br />
                                            <input name="Request_How_Hear_Us" class="formfield" size="30" /></td>
                                    </tr>
                                    <tr>
                                        <td height="20" align="left" valign="top">
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="top">
                                            <input name="Input" type="submit" class="formfield" onclick="return ValidateCUForm();"
                                                value="Submit Information" size="Submit" />
                                            <img src="images/spacer.gif" width="21" height="14" />
                                            <input name="Input" type="reset" class="formfield" value="Reset" size="Reset" /></td>
                                    </tr>
                                    <tr>
                                        <td>
                                        </td>
                                    </tr>
                                </table>
                                <p>
                                    &nbsp;</p>
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
                                                    <li><a href="account_setup.asp">Account Request</a></li>
                                                    <li><a href="getting_tips.asp">Getting Started Tips </a></li>
                                                    <li><a href="../support.asp">Support</a></li>
                                                </ul>
                                            </td>
                                        </tr>
                                    </table>
                                    <br />
                                    <br />
                                    <br />
                                    <br />
                                    <br />
                                    <br />
                                    <br />
                                    <br />
                                    <br />
                                    <br />
                                    <br />
                                    <br />
                                    <br />
                                    <br />
                                    <br />
                                    <br />
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
        </td> </tr> </table>
        <br />
        <br />
    </form>
</body>
</html>
