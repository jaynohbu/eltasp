<%@ Page Language="C#" AutoEventWireup="true" CodeFile="Default2.aspx.cs" Inherits="Default2" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Untitled Page</title>
</head>
<body>
    <form id="form1" runat="server">
        <asp:ScriptManager ID="ScriptManager1" runat="server" />
        <asp:UpdatePanel runat="server" ID="UpdatePanel" UpdateMode="Conditional">
            <Triggers>
                <asp:AsyncPostBackTrigger ControlID="UpdateButton2" EventName="Click" />
            </Triggers>
            <ContentTemplate>
                <asp:Label runat="server" ID="DateTimeLabel1" />
                <asp:Button runat="server" ID="UpdateButton1" OnClick="UpdateButton_Click" Text="Update" />
            </ContentTemplate>
        </asp:UpdatePanel>
        <asp:UpdatePanel runat="server" ID="UpdatePanel1" UpdateMode="Conditional">
            <ContentTemplate>
                <asp:Label runat="server" ID="DateTimeLabel2" />
                <asp:Button runat="server" ID="UpdateButton2" OnClick="UpdateButton_Click" Text="Update" />
            </ContentTemplate>
        </asp:UpdatePanel>
    </form>
</body>
</html>
