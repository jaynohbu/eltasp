<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CreateAdmin.aspx.cs" Inherits="OnlineApply_CreateAdmin" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Create Admin</title>
    <script type="text/jscript">
    </script>
</head>
<body>
    <div style="text-align: center">
        <form id="form1" runat="server">
            <table style="width: 500px">
                <tr>
                    <td>
                        Enter administrator's password for login.<br />
                        You will be asked to enter below information at login screen.
                    </td>
                </tr>
                <tr>
                    <td>
                        <table>
                            <tr>
                                <td align="left">
                                    Account No.
                                </td>
                                <td style="width: 5px">
                                </td>
                                <td>
                                    <asp:Label ID="TxtELTAcct" runat="server"></asp:Label>
                                </td>
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td align="left">
                                    Login ID
                                </td>
                                <td style="width: 5px">
                                </td>
                                <td>
                                    <asp:Label ID="TxtAdminID" runat="server" Text="admin"></asp:Label>
                                </td>
                                <td>
                                </td>
                            </tr>
                            <tr>
                                <td align="left">
                                    Password:
                                </td>
                                <td style="width: 5px">
                                </td>
                                <td>
                                    <asp:TextBox ID="TxtPassword" runat="server" TextMode="Password" Width="150px"></asp:TextBox>
                                </td>
                                <td>
                                    <asp:RequiredFieldValidator ID="RFVTxtPassword" runat="server" ControlToValidate="TxtPassword"
                                        ErrorMessage="*"></asp:RequiredFieldValidator></td>
                            </tr>
                        </table>
                    </td>
                </tr>
                <tr>
                    <td>
                        <asp:Button ID="Button1" runat="server" Text="Create Administrator" OnClick="Button1_Click" /></td>
                </tr>
            </table>
        </form>
    </div>
</body>
</html>
