<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SetupLogin.aspx.cs" Inherits="Authentication_create_login" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>FreightEasy Login</title>
</head>
<body>
    <div style="text-align:center">
        <form id="form1" runat="server">
            <table>
                <tr>
                    <td colspan="3">
                        Enter your email and password.
                    </td>
                </tr>
                <tr>
                    <td align="left">
                        Email Address
                    </td>
                    <td align="left">
                        <asp:TextBox ID="TxtEmail" runat="server" Width="150px"></asp:TextBox>
                    </td>
                    <td>
                        <asp:RequiredFieldValidator ID="RFVTxtEmail" runat="server" ControlToValidate="TxtEmail"
                            ErrorMessage="*"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td align="left">
                        Password
                    </td>
                    <td align="left">
                        <asp:TextBox ID="TxtPassword" runat="server" TextMode="Password" Width="150px"></asp:TextBox>
                    </td>
                    <td>
                    <asp:RequiredFieldValidator ID="RFVTxtPassword" runat="server" ControlToValidate="TxtPassword"
                            ErrorMessage="*"></asp:RequiredFieldValidator>
                    </td>
                </tr>
                <tr>
                    <td colspan="2">
                        <asp:Button ID="Button1" runat="server" Text="Account Creation Login" OnClick="Button1_Click" />
                        <input type="reset" value="Reset" />
                    </td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>
