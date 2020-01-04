<%@ Page Language="C#" AutoEventWireup="true" CodeFile="legal.aspx.cs" Inherits="legal" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
    <title>AES Easy</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <style type="text/css">

        .style2 {
	        color: #1b4d89;
	        font-size: 9px;
        }
        .style3 {font-size: 9px}
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
	        margin-top: 0px;
        }
        a {
	        color: #0066CC;
	        text-decoration: none;
        }
        a:hover {
	        color: #c60000;
        }
        .style8 {color: #333333; font-size: 9px; }
        .style10 {
	        color: #999999;
	        font-size: 9px;
        }
        
        .title {
	        font-family: Verdana, Arial, Helvetica, sans-serif;
	        font-size: 11px;
	        color: #606060;
        }
        
    </style>
    <link href="./CSS/AppStyle.css" type="text/css" rel="stylesheet" />
    <object id="EltClient" classid="CLSID:B38256C8-D8AE-42FF-8B14-B6FAB132E440" codebase="./include/ELTAuth.CAB#version=2,2,0,0">
        <param name="copyright" value="http://www.freighteasy.net" />
    </object>

    <script type="text/JavaScript">

        function MM_openBrWindow(theURL,winName,features) {
            window.open(theURL,winName,features);
        }

        function getInfo(){
            if(!val()) return false;

            try{
	            var sMac = EltClient.ELTMacAddress();
	            var sCom = EltClient.ELTComputerName();
	            var sInt = EltClient.ELTIPAddress();
                
	            if(sMac==null || sMac=='') sMac = 'ActiveX Error';
                document.form1.txtIP.value = sMac;
                document.form1.txtServerName.value = sCom;
                document.form1.txtIntIP.value = sInt;
            }
            catch(e){
	            document.form1.txtIP.value = 'ActiveX Error';
            }	
            if (document.form1.txtIP.value == 'ActiveX Error'){
            }
            return true;
        }

        String.prototype.trim = function(){return this.replace(/(^\s*)|(\s*$)/g, "");}

        function val(){
            if(document.form1.txtClient.value.trim() == ''){
                alert('Please enter the Account No.!');
                document.form1.txtClient.focus();
                return false;
            }

            if(document.form1.txtID.value.trim() == ''){
                alert('Please enter your ID!');
                document.form1.txtID.focus();
                return false;
            }
            
            if(document.form1.txtPwd.value.trim() == ''){
                alert('Please enter your password!');
                document.form1.txtPwd.focus();
                return false;
            }
            return true;
        }

        function GoMain(s0,s1,s2,s3){
            s3 = '';
            if(s0 != 'Y' && s1 != 'Y' && s2 != 'Y' && s3 !='Y' ){
                window.top.location = "/EXP_MAIN/Main.aspx?T=";
            }
            else{
    	        s = s0+"^"+s1+"^"+s2+"^"+s3;
                popResult = showModalDialog("/Freighteasy/ErrorGuide.asp?p="+s,"ErrorGuide","dialogWidth:500px; dialogHeight:275px; help:0; status:0; scroll:0;center:1;Sunken;");                    
                if (popResult == 'go' && s0 != 'Y' && s1 != 'Y' && s2 != 'Y' ){
                    window.top.location = "/EXP_MAIN/Main.aspx?T=";
                }
            }    
        }

    </script>

    <script type="text/JavaScript">

        function MM_preloadImages() { //v3.0
          var d=document; if(d.images){ if(!d.MM_p) d.MM_p=new Array();
            var i,j=d.MM_p.length,a=MM_preloadImages.arguments; for(i=0; i<a.length; i++)
            if (a[i].indexOf("#")!=0){ d.MM_p[j]=new Image; d.MM_p[j++].src=a[i];}}
        }

        function goIFF() 
        {
            window.location = '/freighteasy/index.aspx';
        }

        function MM_swapImgRestore() { //v3.0
          var i,x,a=document.MM_sr; for(i=0;a&&i<a.length&&(x=a[i])&&x.oSrc;i++) x.src=x.oSrc;
        }

        function MM_findObj(n, d) { //v4.01
          var p,i,x;  if(!d) d=document; if((p=n.indexOf("?"))>0&&parent.frames.length) {
            d=parent.frames[n.substring(p+1)].document; n=n.substring(0,p);}
          if(!(x=d[n])&&d.all) x=d.all[n]; for (i=0;!x&&i<d.forms.length;i++) x=d.forms[i][n];
          for(i=0;!x&&d.layers&&i<d.layers.length;i++) x=MM_findObj(n,d.layers[i].document);
          if(!x && d.getElementById) x=d.getElementById(n); return x;
        }

        function MM_swapImage() { //v3.0
          var i,j=0,x,a=MM_swapImage.arguments; document.MM_sr=new Array; for(i=0;i<(a.length-2);i+=3)
           if ((x=MM_findObj(a[i]))!=null){document.MM_sr[j++]=x; if(!x.oSrc) x.oSrc=x.src; x.src=a[i+2];}
        }
        
        function viewPop(Url) {
        
            var strJavaPop = "";
            strJavaPop = window.open(Url,"popupNew","top=0, left=0, staus=0,titlebar=0,toolbar=1,menubar=1,scrollbars=1,resizable=1,location=0,width=850,height=600,hotkeys=0");
            strJavaPop.focus();
        } 

    </script>

</head>
<body>
    <form id="form1" method="post" runat="server">
        <div style="text-align: center">
            <div style="height: 70px; width: 90%; text-align: left" class="pageheader">
                <img src="Images/aeseasy.jpg" alt="" /></div>
            <table cellpadding="2" cellspacing="0" border="0" style="width: 90%; border: solid 1px #cdcdcd">
                <tr valign="top">
                    <td style="width: 210px">
                        <table cellspacing="0" cellpadding="3" border="0" id="tblLogin" style="background-color: #ffffff;
                            width: 100%; border: solid 1px #cdcdcd">
                            <tr>
                                <td colspan="2" style="height: 35px; vertical-align: top">
                                    <img src="./Images/memberlogin.gif" alt="" style="border: none 0px" /></td>
                            </tr>
                            <tr>
                                <td>
                                    Account No:</td>
                                <td>
                                    <asp:TextBox ID="txtClient" runat="server" CssClass="shorttextfield" Width="100px"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td class="title">
                                    User Name:</td>
                                <td>
                                    <asp:TextBox ID="txtID" runat="server" CssClass="shorttextfield" Width="100px" MaxLength="64"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td class="title">
                                    Password:</td>
                                <td>
                                    <asp:TextBox ID="txtPwd" runat="server" CssClass="shorttextfield" Width="100px" MaxLength="16"
                                        TextMode="Password"></asp:TextBox></td>
                            </tr>
                            <tr>
                                <td>
                                </td>
                                <td>
                                    <asp:CheckBox ID="chkRemember" runat="server" Text="Remember me" CssClass="bodycopy">
                                    </asp:CheckBox></td>
                            </tr>
                            <tr style="height: 4px">
                                <td colspan="2">
                                </td>
                            </tr>
                            <tr>
                                <td>
                                </td>
                                <td>
                                    <asp:ImageButton ID="ImgGoMain" runat="server" ImageUrl="../../freighteasy/images/login.gif"
                                        OnClick="ImgGoMain_Click1" /></td>
                            </tr>
                            <tr style="height: 4px">
                                <td colspan="2">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <a href="javascript:viewPop('OnlineApply/NewAccount.aspx');">Get AESEasy account now!</a>
                                </td>
                            </tr>
                            <tr style="height: 4px">
                                <td colspan="2">
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <a href="http://www.e-logitech.net/freighteasy/getting_tips.asp" target="_blank"
                                        onmouseout="MM_swapImgRestore()" onmouseover="MM_swapImage('loginhelp','','./Images/button_login_help_over.gif',1)">
                                        <img src="./Images/button_login_help.gif" alt="" style="border: none 0px" id="loginhelp" /></a>
                                </td>
                            </tr>
                        </table>
                    </td>
                    <td>
                        <table cellpadding="0" cellspacing="0" border="0">
                            <tr>
                                <td colspan="2" align="right" valign="top" bgcolor="#FFFFFF">
                                    &nbsp;</td>
                            </tr>
                            <tr>
                                <td align="left" valign="top" bgcolor="#FFFFFF">
                                    <h1>
                                        Legal &amp; Privacy
                                    </h1>
                                </td>
                                <td align="left" valign="top" bgcolor="#FFFFFF">
                                </td>
                            </tr>
                            <tr>
                                <td align="left" valign="top" bgcolor="#FFFFFF">
                                </td>
                            </tr>
                            <tr>
                                <td valign="center" align="left" colspan="2">
                                    <span class="style4">Instruction</span></td>
                            </tr>
                            <tr>
                                <td bgcolor="#666666" colspan="2">
                                    <img height="1" src="./Images/spacer.gif" width="1" /></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    We want our users to always be aware of any information we collect, how we use it,
                                    and under what circumstances, if any, we disclose it.
                                    <br />
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor="#666666" colspan="2">
                                    <img height="1" src="./Images/spacer.gif" width="1" /></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <span class="style5">WEBSITE ADMINISTRATION </span>
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Business name:
                                </td>
                                <td>
                                    E-Logistics Technology
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Address:
                                </td>
                                <td>
                                    1601 Bayshore Hwy. #321
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    City:
                                </td>
                                <td>
                                    Burlingame
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    State/Province:
                                </td>
                                <td>
                                    CA
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    ZIP:
                                </td>
                                <td>
                                    94010
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Country:
                                </td>
                                <td>
                                    USA
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Website URL:
                                </td>
                                <td>
                                    www.freighteasy.net
                                </td>
                            </tr>
                            <tr>
                                <td valign="top" align="left">
                                    Website e-mail:
                                </td>
                                <td>
                                    info@e-logitech.net
                                    <br />
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor="#666666" colspan="2">
                                    <img height="1" src="freighteasy/images/spacer.gif" width="1" /></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <strong>INFORMATION COLLECTION AND USE</strong></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    We respect each site visitor's right to personal privacy. To that end, we collect
                                    and use information throughout our website only as disclosed in this Privacy Policy.
                                    This statement applies solely to information collected on this website.
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    For each visitor to our website, our web server automatically recognizes only the
                                    visitor's domain name: not the e-mail address.</td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    The information we collect is: used to improve the content of our Web page.</td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    This site does not collect cookies. (<a href="http://www.netlingo.com/right.cfm?term=cookies"
                                        target="_blank">Definition of Cookies</a>)</td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    Registration is not required to enter our site.</td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    We have an order form.</td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    We require information from the user on our order form. A user must provide contact
                                    information (such as name, email, and shipping address) and possibly financial information
                                    (such as credit card number, expiration date). If we have trouble processing an
                                    order, we use the information to contact the user. This information is used:for
                                    shipping and billing purposes.</td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    We always use industry-standard encryption technologies when transferring and receiving
                                    consumer data exchanged with our site. When we transfer and receive certain types
                                    of sensitive information such as financial or health information, we redirect visitors
                                    to a secure server and will notify visitors of this feature through a pop-up screen
                                    on our site. We have appropriate security measures in place in our physical facilities
                                    to protect against the loss, misuse, or alteration of information that we have collected
                                    from you at our site.
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    We publish a newsletter (ezine), and we never sell or share our subscribers' email
                                    addresses.</td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    We operate online surveys, and we never sell or share our subscribers' email addresses.<br />
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor="#666666" colspan="2">
                                    <img height="1" src="./Images/spacer.gif" width="1" /></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <strong>NOTIFICATION OF CHANGES</strong></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    If we decide to change our privacy policy, we will post those changes to:this privacy
                                    statement.<br />
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor="#666666" colspan="2">
                                    <img height="1" src="./Images/spacer.gif" width="1" /></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <strong>CONFLICT RESOLUTION</strong></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    We are committed to resolving disputes within one week.
                                </td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    If problems arise, users may contact us by<br />
                                    email.<br />
                                    telephone.<br />
                                    fax.<br />
                                    <br />
                                </td>
                            </tr>
                            <tr>
                                <td bgcolor="#666666" colspan="2">
                                    <img height="1" src="./Images/spacer.gif" width="1" /></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    <strong>CONTACT INFORMATION</strong></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    If site users have any questions or suggestions regarding our privacy policy, please
                                    contact us at:</td>
                            </tr>
                            <tr>
                                <td>
                                    Email</td>
                                <td>
                                    info@e-logitech.net</td>
                            </tr>
                            <tr>
                                <td>
                                    Postal Address:
                                </td>
                                <td valign="top">
                                    1601 Bayshore Hwy. #321 Burlingame, CA USA 94010
                                </td>
                            </tr>
                            <tr>
                                <td>
                                    Website URL:</td>
                                <td>
                                    <a href="http://www.freighteasy.net">www.freighteasy.net</a></td>
                            </tr>
                            <tr>
                                <td colspan="2">
                                    To further protect your privacy and ensure that we keep our promises to you this
                                    policy has been registered with Privacy Affiliates - A trusted third party privacy
                                    advocate. Here are the contact details. Privacy Affiliates 318-19567 Fraser Highway
                                    Surrey, BC V3S 9A4 email: <a href="mailto:support@privacyaffiliates.com">support@privacyaffiliates.com</a>
                                    Phone: 646-383-1595
                                </td>
                            </tr>
                        </table>
                    </td>
                </tr>
            </table>
            <div>
                <table cellpadding="5" cellspacing="0" border="0">
                    <tr>
                        <td>
                            Copyright&copy; 2006 E-Logistics Technology, Inc. All rights reserved.</td>
                        <td>
                            <a href="\EXP_MAIN/Default.aspx">Home</a> | <a href="\EXP_MAIN/Legal.aspx">Legal &amp;
                                Privacy</a> | <a href="\EXP_MAIN/Contact.aspx">Contact</a></td>
                        <td>
                            <img src="./Images/company_logo.gif" style="border: none 0px" alt="" /></td>
                    </tr>
                </table>
            </div>
        </div>
        <div style="position: absolute; top: 0; left: 0; visibility: hidden; z-index: -1"
            id="divProperties">
            <asp:HiddenField ID="hFreeAccontSession" runat="server" Value="" />
            <asp:TextBox ID="txtIP" runat="server" />
            <asp:TextBox ID="txtServerName" runat="server" />
            <asp:TextBox ID="txtIntIP" runat="server" />
        </div>
    </form>
</body>
</html>
