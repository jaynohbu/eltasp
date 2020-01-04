<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SetupComplete.aspx.cs" Inherits="NewAccount_SetupComplete"
    CodePage="65001" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Setup Completion</title>
    <style type="text/css">
        body, form {
	        border-width : 0px; 
	        margin-top:0px;
	        border-bottom:0px;
	        border-left :0px;
	        border-right :0px;
        }
        .text2 {
	        font-family: Verdana, Arial, Helvetica, sans-serif;
	        font-size: 12px;
	        text-decoration: none;
	        color: #000000;
        }
        .text1 {
	        font-family: Verdana, Arial, Helvetica, sans-serif;
	        font-size: 15px;
	        color: #000000;
	        font-weight: bold;
	        text-transform: none;
	        padding-top: 26px;
	        padding-bottom: 10px;
        }
    </style>
</head>
<body>
    <form id="form1" runat="server">
        <div class="text1">
            Your Setup is completed.
        </div>
        <div class="text2">
            Click below button to finish setup session and activate your new account. Also,
            a email will be sent to you with new account and login information.<br />
            You can alo reconfigurate your account setup at any time. Please, refer our manual
            or contact us for further assistances.
        </div>
        <br />
        <div>
            <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Complete Setup Session"
                CssClass="text2" />
            <asp:Button ID="Button2" runat="server" Text="Previous Step" CssClass="text2" OnClick="Button2_Click" /></div>
    </form>
</body>
</html>
