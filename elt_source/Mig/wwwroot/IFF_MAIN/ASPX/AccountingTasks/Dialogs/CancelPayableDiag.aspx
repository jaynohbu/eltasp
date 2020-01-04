<%@ Page Language="C#" AutoEventWireup="true" CodeFile="CancelPayableDiag.aspx.cs" Inherits="ASPX_AccountingTasks_Dialogs_CancelPayableDiag" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" >
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
    <div>
        <table align="center" border="0" bordercolor="#89a979" cellpadding="0" cellspacing="0"
            class="border1px" width="95%">
            <tr>
                <td align="center" bgcolor="#d5e8cb" height="24" style="width: 7px; border-bottom: #89a979 1px solid"
                    valign="middle">
                </td>
            </tr>
            <tr>
                <td colspan="1" style="height: 19px">
                    Please provide&nbsp; reason to cancel this payment</td>
            </tr>
            <tr>
                <td bgcolor="#f3f3f3" colspan="1" height="18">
                    &nbsp;<asp:TextBox ID="TextBox1" runat="server" Width="266px"></asp:TextBox></td>
            </tr>
            <tr>
                <td style="width: 7px; height: 19px">
                    &nbsp;<asp:Button ID="Button1" runat="server" Text="OK" />
                    <asp:Button ID="Button2" runat="server" Text="Cancel" /></td>
            </tr>
            <tr>
                <td align="center" bgcolor="#d5e8cb" height="24" style="border-top: #89a979 1px solid;
                    width: 7px" valign="middle">
                </td>
            </tr>
        </table>
    
    </div>
    </form>
</body>
</html>
