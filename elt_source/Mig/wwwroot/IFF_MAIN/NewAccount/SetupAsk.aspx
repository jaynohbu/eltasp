<%@ Page Language="C#" AutoEventWireup="true" CodeFile="SetupAsk.aspx.cs" Inherits="NewAccount_SetupAsk" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Setup Wizard Options</title>
    <base target="_self" />
</head>
<body>
    <form id="form1" runat="server">
        <div style="margin-top: 10px; margin-left: 20px">
            <asp:HiddenField ID="hELTAcctNo" runat="server" />
            <asp:RadioButtonList ID="rlSetupOption" runat="server" RepeatDirection="vertical"
                OnSelectedIndexChanged="rlSetupOption_SelectedIndexChanged" AutoPostBack="true">
                <asp:ListItem Value="Y">Run setup wizard now (Recommanded)</asp:ListItem>
                <asp:ListItem Value="L">Run setup wizard 10 days later</asp:ListItem>
                <asp:ListItem Value="N">Never ask for setup wizard</asp:ListItem>
                <asp:ListItem Value="H">I will decide next time when I log in</asp:ListItem>
            </asp:RadioButtonList>
        </div>
    </form>
</body>
</html>
