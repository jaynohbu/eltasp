<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>FreightEasy Home</title>
    <style type="text/css">
        
    </style>
    <script type="text/JavaScript">
<!--
        function viewPop(Url) {
            var strJavaPop = "";
            strJavaPop = window.open(Url, 'popupNew', 'staus=0,titlebar=0,toolbar=1,menubar=1,scrollbars=1,resizable=1,location=0,width=900,height=600,hotkeys=0');
            strJavaPop.focus();
        }

        function GoMain() {
            __doPostBack("btnGoMain", "");
        }

        function MM_preloadImages() { //v3.0
            var d = document; if (d.images) {
                if (!d.MM_p) d.MM_p = new Array();
                var i, j = d.MM_p.length, a = MM_preloadImages.arguments; for (i = 0; i < a.length; i++)
                    if (a[i].indexOf("#") != 0) { d.MM_p[j] = new Image; d.MM_p[j++].src = a[i]; } 
            }
        }

        function goIFF() {
            window.location = '/freighteasy/index.aspx';
        }

//-->
    </script>
    <script  type="text/javascript" id="FORM MACHINE SCRIPTS"><!--
        // @@@@@ FORM MACHINE SCRIPTS Start @@@@@
        function ValidateCUItem(item, name, validate_mail) {
            if (document.ContactUs.elements[item]) {
                if (document.ContactUs.elements[item].value.length < 1) {
                    alert("You must enter a value for " + name);
                    document.ContactUs.elements[item].focus();
                    return false;
                }
                if (validate_mail) {
                    var emailFilter = /^.+@.+\..{2,3}$/;
                    var illegalChars = /[\(\)\<\>\,\;\:\\\/\"\[\]]/;
                    var strng = document.ContactUs.elements[item].value;
                    if (!(emailFilter.test(strng))) {
                        alert("You have entered an invalid email address.");
                        document.ContactUs.elements[item].focus();
                        return false;
                    }
                    if (strng.match(illegalChars)) {
                        alert("Your email address contains invalid characters.");
                        document.ContactUs.elements[item].focus();
                        return false;
                    }
                }
            }
            return true;
        }
        function ValidateCUForm() {
            if (!ValidateCUItem("Request_Name", "Name", false)) return false;
            if (!ValidateCUItem("Request_Company_Name", "Company Name", false)) return false;
            if (!ValidateCUItem("Request_Email", "Email Address", true)) return false;
            return true;
        }

        // @@@@@ FORM MACHINE SCRIPTS End @@@@@
//-->
    </script>
    <link href="freighteasy/css/style_freighteasy.css" rel="stylesheet" type="text/css" />
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <style type="text/css">
body {
    color: #606060;
    font-family: sans-serif;
    font-size: 11px;
    line-height: 1.5em;
}
.style3 {font-family: Verdana, Arial, Helvetica, sans-serif}
.style5 {font-family: Verdana, Arial, Helvetica, sans-serif; font-weight: bold; }

</style>
</head>
<body onload="MM_preloadImages('freighteasy/images/button_elthome_over.gif')">
    <form name="ContactUs" action="contact_thank.asp" method="post">

                            <p>
                                <input id="Redirect_URL" type="hidden" value="freighteasy/contact_thank.asp" name="Redirect_URL" />
                                <input id="MailToName" type="hidden" value="Andy" name="MailToName" />
                                <input id="MailToAddress" type="hidden" value="info@e-logitech.net" name="MailToAddress" /><br />
                                <span class="style5"><font color="d02d17">*</font></span> Required field</p>
                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                <tbody>
                                    <tr>
                                        <td width="386" height="40" align="left" valign="top">
                                            Name<span class="style5"><font color="d02d17">*</font></span><br />
                                            <input name="Request_Name" class="formfield" size="30" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="40" align="left" valign="top">
                                            Title</span><br />
                                            <input name="Request_Title" class="formfield" size="30" />
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="40" align="left" valign="top">
                                            Company Name <span class="style5"><font color="d02d17">*</font></span></span><font
                                                color="d02d17">
                                                <br />
                                                <input name="Request_Company_Name" class="formfield" size="30" />
                                            </font>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="top">
                                            <table width="100%" border="0" cellpadding="0" cellspacing="0">
                                                <tbody>
                                                    <tr>
                                                        <td height="30" align="left" valign="top">
                                                            Address<br />
                                                            <input name="Request_Address" class="formfield" size="34" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td align="left" valign="top">
                                                            <table width="100%" height="46" border="0" cellpadding="0" cellspacing="0">
                                                                <tr>
                                                                    <td width="16%" height="18" align="left" valign="bottom">
                                                                        City
                                                                    </td>
                                                                    <td width="11%" align="left" valign="bottom">
                                                                        State
                                                                    </td>
                                                                    <td width="73%" align="left" valign="bottom">
                                                                        Zip
                                                                    </td>
                                                                </tr>
                                                                <tr>
                                                                    <td align="left" valign="top">
                                                                        <input name="Request_City" class="formfield" size="14" />
                                                                    </td>
                                                                    <td align="left" valign="top">
                                                                        <input name="Request_State" class="formfield" size="5" />
                                                                    </td>
                                                                    <td align="left" valign="top">
                                                                        <input name="Request_Zip" class="formfield" size="8" />
                                                                    </td>
                                                                </tr>
                                                            </table>
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="40" align="left" valign="top">
                                                            E-mail Address <span class="style5"><font color="d02d17">*</font></span><br />
                                                            <input name="Request_Email" class="formfield" size="34" />
                                                            &nbsp; &nbsp;
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="40" align="left" valign="top">
                                                            Phone Number</span><br />
                                                            <input name="Request_Phone_Number" class="formfield" size="20" />
                                                        </td>
                                                    </tr>
                                                    <tr>
                                                        <td height="40" align="left" valign="top">
                                                            Fax Number</span><br />
                                                            <input name="Request_Fax_Number" class="formfield" size="20" />
                                                        </td>
                                                    </tr>
                                                </tbody>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="40" align="left" valign="top">
                                            Best Time to Call</span><br />
                                            <select name="Request_Best_Time_to_Call" class="formfield" size="1" style="width: 140px">
                                                <option selected="selected">8:00 AM - 11:00 AM</option>
                                                <option>11:00 AM - 2:00 PM</option>
                                                <option>2:00 PM - 5:00 PM</option>
                                                <option>5:00 PM - 7:00 PM</option>
                                            </select>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td align="left" valign="top">
                                            Specific Inquiries<br />
                                            <textarea name="Request_Specific_Inquiries" cols="60" rows="6" class="formfield"></textarea>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="20" align="left" valign="top">
                                        </td>
                                    </tr>
                                </tbody>
                                <tr>
                                    <td align="left" valign="top">
                                        <input name="Input" type="submit" class="formfield" onclick="return ValidateCUForm();"
                                            value="Submit Information" size="Submit" />
                                        <img src="freighteasy/images/spacer.gif" width="26" height="1" />
                                        <input name="Input" type="reset" class="formfield" value="Reset" size="Reset" />
                                    </td>
                                </tr>
                                <tr>
                                    <td>
                                    </td>
                                </tr>
                            </table>
                        
           
    </form>
</body>
</html>
