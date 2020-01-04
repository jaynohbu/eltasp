<%@ Page Language="C#" AutoEventWireup="true" CodeFile="NewAccountCreate.aspx.cs"
    Inherits="OnlineRequest_NewAccountCreate" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
    <link href="../ASPX/CSS/AppStyle.css" type="text/css" rel="stylesheet" />

    <script type="text/javascript">
        function close_window()
        {
            var vLoginWin = window.opener.window.frames[0].window;
            vLoginWin.document.getElementById("txtClient").value = document.getElementById("hELTAcct").value;
            vLoginWin.document.getElementById("txtID").value = document.getElementById("hAdminID").value;
            vLoginWin.document.getElementById("txtPwd").value = document.getElementById("hAdminPass").value;
        }
    </script>

</head>
<body onunload="close_window()">
    <form id="form1" runat="server">
        <asp:HiddenField ID="hRequestID" runat="server" />
        <asp:HiddenField ID="hTranID" runat="server" />
        <asp:HiddenField ID="hELTAcct" runat="server" />
        <asp:HiddenField ID="hAdminID" runat="server" />
        <asp:HiddenField ID="hAdminPass" runat="server" />
        <div style="text-align: center">
            <div style="width: 90%; text-align: left; margin-top: 20px; margin-bottom: 20px">
                <img src="../ASP/Images/FElogo_small.gif" alt="" /></div>
            <div style="width: 90%; text-align: center; margin-top: 20px; margin-bottom: 20px">
                <a href="javascript:window.close();">
                    <img src="../Images/button_done.gif" alt="" style="border: none 0px" /></a>
            </div>
            <div style="width: 90%; text-align: left; height: 350px; margin-top: 20px; margin-bottom: 20px;
                border: solid 1px #cdcdcd; padding: 4px; line-height:170%" class="bodyheader">
                Your account has been created and activated.<br />
                You can now access your acccount by entering below information at login screen.<br />
                Click "DONE" button to complete your request.<p />
                Account No: <asp:Label ID="lblELTAcct" runat="server" /><br />
                User Name: <asp:Label ID="lblAdminID" runat="server" /><br />
                Password: <asp:Label ID="lblAdminPass" runat="server" /><p />
                
                Login information has been sent to <asp:Label ID="lblEmailAddress" runat="server" />.
            </div>
            <div style="width: 90%; text-align: center; margin-top: 20px; margin-bottom: 20px">
                <a href="javascript:window.close();">
                    <img src="../Images/button_done.gif" alt="" style="border: none 0px" /></a>
            </div>
        </div>
    </form>
</body>
</html>
