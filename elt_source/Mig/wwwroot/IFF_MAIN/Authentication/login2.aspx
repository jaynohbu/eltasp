<%@ Page Language="c#" Inherits="IFF_MAIN.Authentication.Authentication" CodeFile="login2.aspx.cs" %>

<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN" >
<html>
<head>
    <title>Authentication</title>
    <meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
    <style type="text/css">
        <!--
        .copy {
	        font-family: Verdana, Arial, Helvetica, sans-serif;
	        font-size: 10px;
	        color: #000000;
	        height: 19px;
	        margin: 0px;
	        line-height: 11px;
	        border-top-width: 1px;
	        border-right-width: 1px;
	        border-bottom-width: 1px;
	        border-left-width: 1px;
	        border-top-style: solid;
	        border-right-style: solid;
	        border-bottom-style: solid;
	        border-left-style: solid;
	        border-top-color: #666666;
	        border-right-color: #cccccc;
	        border-bottom-color: #cccccc;
	        border-left-color: #666666;
        } 
        .smallcopy {
	        font-family: Arial, Helvetica, sans-serif;
	        font-size: 10px;
	        color: #606060;
        }
        body {
	        margin-left: 0px;
	        margin-right: 0px;
	        margin-bottom: 0px;
	        font-size: 10px;
	        font-family: Verdana, Arial, Helvetica, sans-serif;
	        color: #66FFFF;
        }
        .title {
	        font-family: Verdana, Arial, Helvetica, sans-serif;
	        font-size: 11px;
	        color: #606060;
        }
        h4 {
	        color: #FF0000;
	        padding: 0px;
	        margin-top: 0.3em;
	        font-weight: normal;
	        font-size: 0.9em;
	        height: 20px;
	        vertical-align: middle;
        }
        .style3 {color: #b83423}
        -->
    </style>

    <script type="text/JavaScript">
        <!--
        function MM_openBrWindow(theURL,winName,features) { //v2.0
          window.open(theURL,winName,features);
        }
        //-->
    </script>
    <script type="text/javascript" src="../ASP/include/Math.uuid.js" />
    <object id="EltClient" classid="CLSID:B38256C8-D8AE-42FF-8B14-B6FAB132E440" codebase="../ASP/include/ELTAuth.CAB#version=2,2,0,0">
        <param name="copyright" value="http://www.freighteasy.net" />
    </object>
    <meta content="Microsoft Visual Studio .NET 7.1" name="GENERATOR" />
    <meta content="C#" name="CODE_LANGUAGE" />
    <meta content="JavaScript" name="vs_defaultClientScript" />
    <meta content="http://schemas.microsoft.com/intellisense/ie5" name="vs_targetSchema" />

    <script type="text/javascript" event="OnError(ErrMsg)" for="EltClient" language="JavaScript">
             alert("Error has occurred:" +  ErrMsg);
    </script>

    <script type="text/javascript" language="javascript">
        <!--
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

        function GoMain(s0, s1, s2, s3) {
            window.top.location = "/IFF_MAIN/Main.aspx?T=";
//            s3 = '';
//            if(s0 != 'Y' && s1 != 'Y' && s2 != 'Y' && s3 !='Y' ) {
//                window.top.location = "/IFF_MAIN/Main.aspx?T=";
//            }
//            else
//            {
//    	        s = s0+"^"+s1+"^"+s2+"^"+s3;
//                popResult = showModalDialog("/Freighteasy/ErrorGuide.asp?p="+s,"ErrorGuide","dialogWidth:500px; dialogHeight:275px; help:0; status:0; scroll:0;center:1;Sunken;");                    
//                if (popResult == 'go' && s0 != 'Y' && s1 != 'Y' && s2 != 'Y' ){
//                    window.top.location = "/IFF_MAIN/Main.aspx?T=";
//                }
//            }    
        }
        //-->
    </script>

</head>
<body topmargin="0" oncontextmenu="return false">
    <form id="form1" method="post" runat="server">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr>
                <td height="17" colspan="2" class="title">
                    <span class="style3">&nbsp;</span></td>
            </tr>
            <tr>
                <td height="21" class="title">
                    Account No:
                </td>
                <td align="left" valign="top">
                    <asp:TextBox ID="txtClient" runat="server" CssClass="copy" Style="height: 15" size="12"
                        MaxLength="14"></asp:TextBox></td>
            </tr>
            <tr>
                <td height="21" class="title">
                    User Name:
                </td>
                <td align="left" valign="top">
                    <asp:TextBox ID="txtID" runat="server" CssClass="copy" Style="height: 15" size="12"
                        MaxLength="50"></asp:TextBox></td>
            </tr>
            <tr>
                <td height="21" class="title">
                    Password:
                </td>
                <td align="left" valign="top">
                    <asp:TextBox ID="txtPwd" runat="server" CssClass="copy" Style="height: 15" size="12"
                        MaxLength="16" TextMode="Password"></asp:TextBox></td>
            </tr>
            <tr>
                <td>
                    &nbsp;</td>
                <td height="21" align="left" valign="bottom" class="smallcopy">
                    <asp:CheckBox ID="chkRemember" runat="server" Text="Remember" /></td>
            </tr>
            <tr>
                <td>
                    &nbsp;</td>
                <td height="25" align="left" valign="bottom">
                    <asp:ImageButton ID="ImgGoMain" runat="server" ImageUrl="../../freighteasy/images/login.gif"
                        OnClick="ImgGoMain_Click1" />&nbsp;
                </td>
            </tr>
        </table>
        <asp:Button ID="btnChangeUser" runat="server" Visible="False" OnClick="btnChangeUser_Click">
        </asp:Button>
        <asp:TextBox ID="txtIP" runat="server" Width="0px" Height="0px"></asp:TextBox>
        <asp:TextBox ID="txtServerName" runat="server" Height="0px" Width="0px"></asp:TextBox>
        <asp:TextBox ID="txtIntIP" runat="server" Height="0px" Width="0px"></asp:TextBox>
        <asp:Label ID="lblMsg" runat="server" Visible="False"></asp:Label>
        <asp:ImageButton ID="btnLogOut" runat="server" ImageUrl="/IFF_MAIN/ASP/images/icon_logout.gif"
            OnClick="btnOut_Click" />
        <asp:Button ID="btnGoMain" runat="server" OnClick="GoMain_Click" Text="Go" />
    </form>
</body>
</html>
