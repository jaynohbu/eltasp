<%@ Page Language="c#" Inherits="IFF_MAIN.Authentication.Authentication" CodeFile="Login.aspx.cs" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
    <title>Authentication</title>
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
  </style>

    <script type="text/JavaScript">
        function MM_openBrWindow(theURL,winName,features) {
            window.open(theURL,winName,features);
        }
    </script>

    <object id="EltClient" classid="CLSID:B38256C8-D8AE-42FF-8B14-B6FAB132E440" codebase="../ASP/include/ELTAuth.CAB#version=2,2,0,0">
        <param name="copyright" value="http://www.freighteasy.net" />
    </object>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR" />
    <meta content="C#" name="CODE_LANGUAGE" />
    <meta content="JavaScript" name="vs_defaultClientScript" />
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />
    <link href="../ASPX/CSS/AppStyle.css" type="text/css" rel="stylesheet" />

    <script event="OnError(ErrMsg)" for="EltClient" language="JavaScript" type="text/javascript">
        alert("Error was occured:" +  ErrMsg);
    </script>
    <script type="text/javascript" src="../ASP/include/Math.uuid.js" />
    <script language="javascript" type="text/javascript">
        function getInfo() {
            if(!val()) return false;

            try
            {
	            var sMac = Math.uuid(15); // EltClient.ELTMacAddress();
	            var sCom = EltClient.ELTComputerName();
	            var sInt = EltClient.ELTIPAddress();
                
	            if(sMac==null || sMac=='') sMac = 'ActiveX Error';
                document.form1.txtIP.value = sMac;
                document.form1.txtServerName.value = sCom;
                document.form1.txtIntIP.value = sInt;  
            }
            catch (e)
            {
	            document.form1.txtIP.value = 'ActiveX Error';
            }	

            if (document.form1.txtIP.value == 'ActiveX Error')
            {
                return false;
            }

            return true;
        }

        String.prototype.trim = function()
        {
            return this.replace(/(^\s*)|(\s*$)/g, "");
        }

        function val() 
        {
            
            if(document.form1.txtClient.value.trim() == '')
            {
                alert('Please enter the Account No.!');
                document.form1.txtClient.focus();
                return false;
            }

            if(document.form1.txtID.value.trim() == '')
            {
                alert('Please enter your ID!');
                document.form1.txtID.focus();
                return false;
            }
            
            if(document.form1.txtPwd.value.trim() == '')
            {
                alert('Please enter your password!');
                document.form1.txtPwd.focus();
                return false;
            }
                return true;
            
        }
    </script>
</head>

<script language="JavaScript" type="text/javascript">
    function winMaximizer() {
        return;
        if (document.layers) {
            larg = screen.availWidth - 10;
            altez = screen.availHeight - 20;
        } else {
            var larg = screen.availWidth;
            var altez = screen.availHeight;
        }
        self.resizeTo(larg, altez);
        self.moveTo(0, 0);
    }

    function GoMain(s0, s1, s2, s3) {
        window.top.location = "/IFF_MAIN/Main.aspx?T=";
//        s3 = '';
//        if(s0 != 'Y' && s1 != 'Y' && s2 != 'Y' && s3 !='Y' ) {
//            window.top.location = "/IFF_MAIN/Main.aspx?T=";
//        }
//        else
//        {
//    	    s = s0+"^"+s1+"^"+s2+"^"+s3;
//            popResult = showModalDialog("/Freighteasy/ErrorGuide.asp?p="+s,"ErrorGuide","dialogWidth:500px; dialogHeight:275px; help:0; status:0; scroll:0;center:1;Sunken;");                    
//            if (popResult == 'go' && s0 != 'Y' && s1 != 'Y' && s2 != 'Y' ){
//                window.top.location = "/IFF_MAIN/Main.aspx?T=";
//            }
//        }    
    }
</script>

<body topmargin="0" onload="winMaximizer()" oncontextmenu="return false">
    <form id="form1" method="post" runat="server">
        <asp:HiddenField ID="hFreeAccontSession" runat="server" Value="" />
        <table width="100%" border="0" cellpadding="0" cellspacing="0" id="Table1">
            <tr>
                <td>
                    <table width="100%" height="83" border="0" cellpadding="0" cellspacing="0" id="Table2">
                        <tr>
                            <td height="56" align="left" valign="top" bgcolor="#FFFFFF">
                                <asp:Image ID="imgClient_logo" runat="server" ImageAlign="AbsMiddle" ImageUrl="/IFF_MAIN/ClientLogos/default.gif" /></td>
                        </tr>
                        <tr>
                            <td height="22" align="left" valign="top" bgcolor="#eec983">
                                <img height="22" src="../images/spacer.gif" width="1"></td>
                        </tr>
                        <tr>
                            <td height="1" align="left" valign="top">
                                <img height="1" src="../images/spacer.gif" width="1"></td>
                        </tr>
                        <tr>
                            <td valign="top" align="left" bgcolor="#f9ecd4" height="4">
                                <img height="4" src="../images/spacer.gif" width="1"></td>
                        </tr>
                    </table>
                </td>
            </tr>
            <tr>
                <td style="height: 140px">
                </td>
            </tr>
            <tr>
                <td valign="top" align="right">
                    <table id="Table8" style="width: 896px; height: 283px" cellspacing="0" cellpadding="0"
                        width="896" border="0">
                        <tr>
                            <td width="23%">
                            </td>
                            <td width="66%" valign="top">
                                <table id="Table3" cellspacing="0" cellpadding="3" width="54%" align="right" bgcolor="#ffffff"
                                    border="0">
                                    <tr>
                                        <td valign="top" align="left" style="height: 14px">
                                            <table id="Table4" cellspacing="0" cellpadding="0" width="100%" border="0">
                                                <tr>
                                                    <td height="34" align="left" valign="bottom" style="height: 24px">
                                                    </td>
                                                </tr>
                                            </table>
                                            <p class="bodycopy" align="left">
                                                <asp:Label CssClass="pageheader" ID="Label1" runat="server">MEMBER LOGIN</asp:Label>
                                            </p>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td style="height: 12px" valign="top" align="left">
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table id="Table5" cellspacing="0" cellpadding="3" width="100%" border="0">
                                                <tr>
                                                    <td width="22%" align="left" valign="middle">
                                                        <asp:Label ID="lblAccount" runat="server" Text="Account No" CssClass="bodycopy"></asp:Label></td>
                                                    <td width="78%" align="left" valign="middle">
                                                        <asp:TextBox ID="txtClient" runat="server" class="shorttextfield" size="18"></asp:TextBox></td>
                                                </tr>
                                                <tr>
                                                    <td width="22%" align="left" valign="middle" class="bodycopy" style="height: 18px">
                                                        User name</td>
                                                    <td width="78%" align="left" valign="middle" style="height: 18px">
                                                        <asp:TextBox ID="txtID" runat="server" class="shorttextfield" size="18" MaxLength="64"></asp:TextBox></td>
                                                </tr>
                                                <tr>
                                                    <td width="22%" align="left" valign="middle" class="bodycopy">
                                                        Password</td>
                                                    <td width="78%" align="left" valign="middle">
                                                        <asp:TextBox ID="txtPwd" runat="server" class="shorttextfield" size="18" MaxLength="16"
                                                            TextMode="Password"></asp:TextBox></td>
                                                </tr>
                                            </table>
                                            <table id="Table6" cellspacing="0" cellpadding="0" width="100%" border="0">
                                                <tr>
                                                    <td valign="middle" align="left" width="21%">
                                                        &nbsp;</td>
                                                    <td valign="bottom" align="left" width="79%">
                                                    </td>
                                                </tr>
                                            </table>
                                            <table id="Table7" cellspacing="0" cellpadding="0" width="100%" border="0">
                                                <tr>
                                                    <td align="left" valign="middle" width="22%">
                                                    </td>
                                                    <td align="left" valign="bottom" width="78%">
                                                        <asp:CheckBox ID="chkRemember" runat="server" Text="Remember me" CssClass="bodycopy">
                                                        </asp:CheckBox></td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle" align="left" style="height: 1px">
                                                        &nbsp;</td>
                                                    <td valign="bottom" align="left" style="height: 1px">
                                                        &nbsp;</td>
                                                </tr>
                                                <tr>
                                                    <td valign="middle" align="left" width="22%" style="height: 1px">
                                                        &nbsp;</td>
                                                    <td valign="bottom" align="left" width="78%" style="height: 1px">
                                                        <asp:ImageButton ID="ImgGoMain" runat="server" ImageUrl="../../freighteasy/images/login.gif"
                                                            OnClick="ImgGoMain_Click1" /></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td>
                                            <table id="Table8" cellspacing="0" cellpadding="0" width="100%" border="0">
                                                <tr>
                                                    <td valign="middle" align="left" width="22%" style="height: 20px">
                                                        &nbsp;</td>
                                                    <td width="78%" align="left" valign="bottom" class="bodycopy" style="height: 20px">
                                                        <span class="style3">&nbsp;Can't login?</span><span class="style2"> <a href="javascript:return;"
                                                            onclick="MM_openBrWindow('/iff_main/Authentication/login_help.htm','LoginHelp','scrollbars=yes,width=804')">
                                                            Click here for help.</a></span></td>
                                                </tr>
                                            </table>
                                        </td>
                                    </tr>
                                    <tr>
                                        <td height="125">
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td>
                                            &nbsp;</td>
                                    </tr>
                                    <tr>
                                        <td height="24" class="bodycopy">
                                            <span class="style8">Powered by</span> <a href="http://www.e-logitech.net" target="_blank">
                                                <img src="/iff_main/ASP/Images/FElogo_small.gif" width="108" height="23" border="0"
                                                    align="absmiddle"></a></td>
                                    </tr>
                                    <tr>
                                        <td class="bodycopy style10">
                                            <span class="style10">FreightEasy is a trademark of</span> <a href="http://www.e-logitech.net"
                                                target="_blank">E-Logistics Technology, Inc.</a>
                                        </td>
                                    </tr>
                                </table>
                            </td>
                            <td>
                                &nbsp;</td>
                        </tr>
                    </table>
                </td>
            </tr>
        </table>
        <asp:TextBox ID="txtIP" runat="server" style="display:none"></asp:TextBox>
        <asp:TextBox ID="txtServerName" runat="server" style="display:none"></asp:TextBox>
        <asp:TextBox ID="txtIntIP" runat="server" style="display:none"></asp:TextBox>
    </form>
</body>
</html>
