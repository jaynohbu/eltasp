<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head>
    <title>FreightEasy Home</title>
<style type="text/css"></style>
<script type="text/JavaScript">
<!--
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
//-->
</script>
<SCRIPT language=JavaScript id="FORM MACHINE SCRIPTS"><!--
// @@@@@ FORM MACHINE SCRIPTS Start @@@@@
function ValidateCUItem(item, name, validate_mail)
{
  if (document.ContactUs.elements[item]) {
    if (document.ContactUs.elements[item].value.length < 1)
    {  alert("You must enter a value for " + name);
      document.ContactUs.elements[item].focus();
      return false;
    }
    if (validate_mail)
    {
      var emailFilter=/^.+@.+\..{2,3}$/;
      var illegalChars= /[\(\)\<\>\,\;\:\\\/\"\[\]]/;
      var strng = document.ContactUs.elements[item].value;
      if (!(emailFilter.test(strng)))
      { alert("You have entered an invalid email address.");
        document.ContactUs.elements[item].focus();
        return false;
      }
      if (strng.match(illegalChars))
      { alert("Your email address contains invalid characters.");
        document.ContactUs.elements[item].focus();
        return false;
      }
    }
  }
  return true;
}
function ValidateCUForm()
{
    if (!ValidateCUItem("Request_Name", "Name", false)) return false;
    if (!ValidateCUItem("Request_Email", "Email Address", true)) return false;
    return true;
}

// @@@@@ FORM MACHINE SCRIPTS End @@@@@
//-->
</SCRIPT>
<link href="css/style_freighteasy.css" rel="stylesheet" type="text/css" />
<style type="text/css">
<!--
#home {
	position:absolute;
	width:48px;
	height:20;
	z-index:1;
	left: 17px;
	top: 579px;
}
#legal {
	position:absolute;
	width:75;
	height:20;
	z-index:2;
	left: 76px;
	top: 579px;
}
#Layer1 {
	position:absolute;
	width:45px;
	height:20;
	z-index:3;
	left: 165px;
	top: 579px;
}
a {
	color: #FF9966;
}
body,td,th {
	font-family: Arial, Helvetica, sans-serif;
}
a:link {
	color: #333399;
}
body {
	margin-left: 0px;
	margin-top: 0px;
	margin-right: 0px;
	margin-bottom: 0px;
}
.style2 {color: #d02d17}
.style5 {color: #FF0000}
-->
</style>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
</head>
<body onLoad="MM_preloadImages('images/button_elthome_over.gif')">
     <FORM name=AccountSetup action=account_thank_acount.asp method=post>
<table width="100%" border="0" cellpadding="0" cellspacing="0" background="images/background_page.gif">
  <tr>
    <td align="left" valign="top">
	<table width="793" height="42" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td><% 
            Server.Execute("/Include/main_menu.htm")
%></td>
  </tr>
</table>
<table width="793" height="0" border="0" align="left" cellpadding="0" cellspacing="0" background="images/background_body_long.gif">
  
  <tr>
    <td width="624" height="55" align="left" valign="top"><table width="624" height="60" border="0" cellpadding="0" cellspacing="0">
      <tr>
        <td width="17" height="16" align="left" valign="middle"></td>
        <td width="600" height="16" align="left" valign="bottom" class="breadcrumb">
          <a href="../index.asp">ELT Home /</a> Contact </td>
      </tr>
      <tr>
        <td height="43" align="left" valign="top">&nbsp;</td>
        <td height="43" align="left" valign="bottom"><a href="index.aspx"><img src="images/freighteasy_logo.gif" width="118" height="38" border="0" onclick="javascript:goIFF();"></a><img src="images/spacer.gif" width="276" height="1"><img src="images/question.gif" width="213" height="38" /></td>
      </tr>
      <tr>
        <td height="1" colspan="2" align="left" valign="top"></td>
        </tr>
    </table></td><td width="169">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="2" height="249" align="left" valign="top"><table width="793" border="0" cellspacing="0" cellpadding="0">
      <tr>
        <td width="623" align="left" valign="top"><table width="623" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td width="17" height="17" bgcolor="#FFFFFF">&nbsp;</td>
            <td width="590" bgcolor="#FFFFFF">&nbsp;</td>
            <td width="17" bgcolor="#FFFFFF">&nbsp;</td>
          </tr>
          <tr>
            <td height="25" bgcolor="#FFFFFF">&nbsp;</td>
            <td align="left" valign="top" bgcolor="#FFFFFF" class="pageheader">Request Free Trial Account Setup </td>
            <td bgcolor="#FFFFFF">&nbsp;</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF">&nbsp;</td>
            <td width="590" align="left" valign="top" bgcolor="#FFFFFF" class="bodycopy">Remember, FreightEasy&trade; is <a href="web_based.asp">web-based</a>, so there are no  special hardware requirements and you don&rsquo;t have to wait on a software  installation. Once we setup your account with some basic info, you can log on  immediately and start using the system. The trial is a full version of our  system with some placeholder data entered, so you will get a realistic  feel.&nbsp; Any data you enter of your own  will be erased at the end of the trial period, or transferred to your new account  if you decide to buy our system.&nbsp; The  trial period will last one week.&nbsp; Please fill  out the questionnaire below and we will get back to you with your own unique  user name and password.<br />
              <br />
              <input id="Redirect_URL" type="hidden" 
                        value="freighteasy/account_thank.asp"
                        name="Redirect_URL" />
              <input id="MailToName" type="hidden" 
                        value="Andy" name="MailToName" />
              <input id="MailToAddress" 
                        type="hidden" value="info@e-logitech.net"
                        name="MailToAddress" />
              <br />
              <font color="d02d17">* Required field</font><span class="style5">*</span><br />
              <br />
              <table width="85%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                  <tr>
                    <td width="386" height="40" align="left" valign="top">Name <strong><font color="d02d17">*</font></strong><br />
                        <input name="Request_Name" class="bodycopy" size="30" /></td>
                  </tr>
                  <tr>
                    <td height="40" align="left" valign="top">Title<br />
                        <input name="Request_Title" class="bodycopy" size="30" />                    </td>
                  </tr>
                  <tr>
                    <td height="40" align="left" valign="top">Company Name <font color="d02d17"><br />
                    </font>
                      <input name="Company_Name" class="bodycopy" size="30" /></td>
                  </tr>
                  
                  <tr>
                    <td align="left" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                          <tr>
                            <td height="40" align="left" valign="top">Address<br />
                              <input name="Request_Address" class="bodycopy" size="34" /></td>
                          </tr>
                          <tr>
                            <td align="left" valign="top"><table width="100%" height="46" border="0" cellpadding="0" cellspacing="0">
                              <tr>
                                <td width="27%" height="18" align="left" valign="top">City</td>
                                <td width="18%" align="left" valign="top">State</td>
                                <td width="55%" align="left" valign="top">Zip</td>
                              </tr>
                              <tr>
                                <td align="left" valign="top"><input name="Request_City" class="bodycopy" size="14" /></td>
                                <td align="left" valign="top"><input name="Request_State" class="bodycopy" size="5" /></td>
                                <td align="left" valign="top"><input name="Request_Zip" class="bodycopy" size="8" /></td>
                              </tr>
                            </table></td>
                          </tr>
                          <tr>
                            <td height="40" align="left" valign="top">E-mail 
                      Address <strong><font color="d02d17">*</font></strong><br />
                      <input name="Request_Email" class="bodycopy" size="34" />
&nbsp; &nbsp;</td>
                          </tr>
                          <tr>
                            <td height="40" align="left" valign="top">Phone Number<br />
                              <input name="Request_Phone_Number" class="bodycopy" size="20" /></td>
                          </tr>
                    </table></td>
                  </tr>
                  <tr>
                    <td height="20" align="left" valign="top"><span class="bodycopy">Please select features most important to you.</span></td>
                  </tr>
				                    <tr>
                    <td height="20" align="left" valign="top"><table width="100%" border="0" cellpadding="0" cellspacing="0" class="bodycopy">
                      <tr>
                        <td class="bodycopy_indent">&nbsp;</td>
                        <td class="bodycopy_indent">Very Important </td>
                        <td class="bodycopy_indent">Somewhat Important</td>
                        <td class="bodycopy_indent">Not Important </td>
                      </tr>
                      <tr>
                        <td width="176" class="bodycopy_indent">Ease of starup </td>
                        <td width="94" class="bodycopy_indent">&nbsp;</td>
                        <td width="111" class="bodycopy_indent">&nbsp;</td>
                        <td width="90" class="bodycopy_indent">&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="bodycopy_indent">Low cost of starup </td>
                        <td class="bodycopy_indent">&nbsp;</td>
                        <td class="bodycopy_indent">&nbsp;</td>
                        <td class="bodycopy_indent">&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="bodycopy_indent">Low monthly fee </td>
                        <td class="bodycopy_indent">&nbsp;</td>
                        <td class="bodycopy_indent">&nbsp;</td>
                        <td class="bodycopy_indent">&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="bodycopy_indent">Mobility of system </td>
                        <td class="bodycopy_indent">&nbsp;</td>
                        <td class="bodycopy_indent">&nbsp;</td>
                        <td class="bodycopy_indent">&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="bodycopy_indent">Accounting features </td>
                        <td class="bodycopy_indent">&nbsp;</td>
                        <td class="bodycopy_indent">&nbsp;</td>
                        <td class="bodycopy_indent">&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="bodycopy_indent">AMS/AES connectivity </td>
                        <td class="bodycopy_indent">&nbsp;</td>
                        <td class="bodycopy_indent">&nbsp;</td>
                        <td class="bodycopy_indent">&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="bodycopy_indent">Design of system/workflow </td>
                        <td class="bodycopy_indent">&nbsp;</td>
                        <td class="bodycopy_indent">&nbsp;</td>
                        <td class="bodycopy_indent">&nbsp;</td>
                      </tr>
                      <tr>
                        <td class="bodycopy_indent">Technical support/Customer service </td>
                        <td class="bodycopy_indent">&nbsp;</td>
                        <td class="bodycopy_indent">&nbsp;</td>
                        <td class="bodycopy_indent">&nbsp;</td>
                      </tr>
                    </table></td>
                  </tr>
				                    <tr>
                    <td height="20" align="left" valign="top">What Freight Forwarding System are you currently using?<br />
                      <input name="Request_Current_System" class="bodycopy" size="20" /></td>
                  </tr>
				                    <tr>
                    <td height="20" align="left" valign="top">How many employees do you have?<br />
                      <input name="Request_Employee_Number" class="bodycopy" size="20" /></td>
                  </tr>
				                    <tr>
                    <td height="20" align="left" valign="top">How did you hear about us? <br />
                      <input name="Request_How_Hear_Us" class="bodycopy" size="20" /></td>
                  </tr>
				                    <tr>
                    <td height="20" align="left" valign="top">&nbsp;</td>
                  </tr>
				  
                <tr>
                  <td align="left" valign="top">
                    <input name="Input" type="submit" class="bodycopy" onclick="return ValidateCUForm();" value="Submit Information" size="Submit"/>
                    <img src="images/spacer.gif" width="21" height="14" />
                    <input name="Input" type="reset" class="bodycopy" value="Reset" size="Reset" /></td>
                </tr>
                <tr>
                  <td></td>
                </tr>
              </table>
              <br />
<br /></td>
            <td bgcolor="#FFFFFF">&nbsp;</td>
          </tr>
          <tr>
            <td bgcolor="#FFFFFF">&nbsp;</td>
            <td height="42" align="left" valign="top" bgcolor="#FFFFFF">&nbsp;</td>
            <td bgcolor="#FFFFFF">&nbsp;</td>
          </tr>
        </table>
</td>
        <td width="1" align="left" valign="top" bgcolor="#d9d9d9"><table width="1" height="249" border="0" cellpadding="0" cellspacing="0" bgcolor="#f7f1ea">
  <tr>
    <td width="1" height="249" align="left" valign="top"></td>
  </tr>
</table>
</td>
        <td width="169" align="left" valign="top"><table width="169" border="0" cellspacing="0" cellpadding="0">
          <tr>
            <td><table width="169" height="249" border="0" cellpadding="0" cellspacing="0">
              <tr>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
              </tr>
              <tr>
                <td>&nbsp;</td>
              </tr>
            </table></td>
          </tr>
          <tr>
            <td><table width="169" height="216" border="0" cellpadding="0" cellspacing="0" background="images/back_sidetab.gif">
              <tr>
                
                <td width="24" height="24" align="left" valign="top"><img src="images/icon_pro_home.gif" width="23" height="23" /></td>
                <td width="137" class="link_header">FreightEasy Home </td>
                <td width="8" class="link_header">&nbsp;</td>
              </tr>
              <tr>
                
                <td height="24">&nbsp;</td>
                <td align="left" valign="middle" class="navi"><a href="introduction.asp">Introduction</a></td>
                <td align="left" valign="middle" class="navi">&nbsp;</td>
              </tr>
              <tr>
                
                <td height="24">&nbsp;</td>
                <td align="left" valign="middle" class="navi"><a href="why_fe.asp">Why FreightEasy</a></td>
                <td align="left" valign="middle" class="navi">&nbsp;</td>
              </tr>
              <tr>
                
                <td height="24">&nbsp;</td>
                <td align="left" valign="middle" class="navi"><a href="features.asp">Features</a></td>
                <td align="left" valign="middle" class="navi">&nbsp;</td>
              </tr>
              <tr>
                
                <td height="24">&nbsp;</td>
                <td align="left" valign="middle" class="navi"><a href="faqs.asp">FAQs</a></td>
                <td align="left" valign="middle" class="navi">&nbsp;</td>
              </tr>
              <tr>
                
                <td height="24" align="left" valign="top"><img src="images/icon_links.gif" width="23" height="23" /></td>
                <td class="link_header">Quick Links </td>
                <td class="link_header">&nbsp;</td>
              </tr>
              <tr>
               
                <td height="24">&nbsp;</td>
                <td align="left" valign="middle" class="navi"><a href="account_setup.asp">Request Free Trial Account</a> </td>
                <td align="left" valign="middle" class="navi">&nbsp;</td>
              </tr>
              <tr>
               
                <td height="24">&nbsp;</td>
                <td align="left" valign="middle" class="navi"><a href="getting_tips.asp">Getting Started Tips</a> </td>
                <td align="left" valign="middle" class="navi">&nbsp;</td>
              </tr>
              <tr>
                
                <td height="24">&nbsp;</td>
                <td align="left" valign="middle" class="navi"><a href="../support.asp">Support</a></td>
                <td align="left" valign="middle" class="navi">&nbsp;</td>
              </tr>
            </table></td>
          </tr>
        </table></td>
      </tr>
      
    </table></td>
  </tr>
</table>
</td>
  </tr>
</table>

     <table width="100%" border="0" cellspacing="0" cellpadding="0">
       <tr>
         <td height="1" align="left" valign="top" bgcolor="e6e6e6"></td>
       </tr>
       <tr>
         <td><table width="793" border="0" cellspacing="0" cellpadding="0">
             <tr>
               <td width="17">&nbsp;</td>
               <td width="313"><img src="images/spacer.gif" width="313" height="13" /><a href="../index.asp"><img src="images/footer_home.gif" width="47" height="17" border="0" /></a><img src="images/footer_middle.gif" width="13" height="17" /><a href="../legal.asp"><img src="images/footer_legal.gif" width="75" height="17" border="0" /></a><img src="images/footer_middle.gif" width="13" height="17" /><a href="../contact2.asp"><img src="images/footer_contact.gif" width="42" height="17" border="0" /></a><img src="images/spacer.gif" width="123" height="17" /><img src="images/footer.gif" width="281" height="15" /><img src="images/spacer.gif" width="313" height="10" /></td>
               <td width="463">&nbsp;</td>
             </tr>
         </table></td>
       </tr>
     </table>
     </form>
</body>

</html>